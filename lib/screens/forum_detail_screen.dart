import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/forum_model.dart';
import '../providers/forum_provider.dart';

class ForumDetailScreen extends StatefulWidget {
  final ForumModel forum;

  const ForumDetailScreen({Key? key, required this.forum}) : super(key: key);

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  
  List<dynamic> _comments = [];
  bool _isLoading = true;
  String? _currentUserId; 

  @override
  void initState() {
    super.initState();
    _checkUser();
    _loadComments();
  }

  void _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId');
    });
  }

  void _loadComments() async {
    final provider = Provider.of<ForumProvider>(context, listen: false);
    final comments = await provider.fetchComments(widget.forum.id);
    setState(() {
      _comments = comments;
      _isLoading = false;
    });
  }

  void _handleReply(String authorName) {
    setState(() {
      String mentionText = "@$authorName ";
      if (_commentController.text.isNotEmpty) {
        _commentController.text = _commentController.text + " " + mentionText;
      } else {
        _commentController.text = mentionText;
      }
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length)
      );
    });
    FocusScope.of(context).requestFocus(_inputFocusNode);
  }

  // LOGIKA EDIT TOPIK (DENGAN GAMBAR)
  void _showEditDialog() {
    final titleCtrl = TextEditingController(text: widget.forum.judul);
    final descCtrl = TextEditingController(text: widget.forum.deskripsi);
    File? newImageFile; // Variabel untuk nampung gambar baru

    // Kita butuh StatefulBuilder agar Dialog bisa refresh tampilan saat gambar dipilih
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          
          // Fungsi ambil gambar dalam dialog
          Future<void> pickNewImage() async {
            final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setStateDialog(() { // Update tampilan DIALOG
                newImageFile = File(picked.path);
              });
            }
          }

          return AlertDialog(
            title: Text("Edit Diskusi"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(controller: titleCtrl, decoration: InputDecoration(labelText: "Judul")),
                  SizedBox(height: 10),
                  TextField(controller: descCtrl, decoration: InputDecoration(labelText: "Deskripsi"), maxLines: 3),
                  SizedBox(height: 15),
                  Text("Gambar:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  
                  // AREA PILIH GAMBAR
                  GestureDetector(
                    onTap: pickNewImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: newImageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(newImageFile!, fit: BoxFit.cover), // Tampilkan gambar baru yg dipilih
                            )
                          : (widget.forum.gambarUrl != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(widget.forum.gambarUrl!, fit: BoxFit.cover), // Tampilkan gambar lama
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                                    Text("Tambah Foto", style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                    ),
                  ),
                  if (newImageFile != null)
                    Center(child: TextButton(onPressed: pickNewImage, child: Text("Ganti Foto Lain"))),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Batal")),
              ElevatedButton(
                onPressed: () async {
                  // Tampilkan Loading (opsional) atau langsung proses
                  Navigator.pop(ctx); // Tutup dialog dulu
                  
                  bool success = await Provider.of<ForumProvider>(context, listen: false)
                      .updateForum(widget.forum.id, titleCtrl.text, descCtrl.text, newImageFile);
                  
                  if (success) {
                    // Refresh halaman ini (agar judul/deskripsi berubah)
                    // Note: Untuk gambar berubah real-time, idealnya kita fetch ulang dari server
                    if (_currentUserId != null) {
                        Provider.of<ForumProvider>(context, listen: false).fetchForums(_currentUserId!);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Berhasil diedit")));
                    
                    // Delay sedikit lalu back agar user melihat perubahan di list (opsional)
                    // Navigator.pop(context); 
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mengupdate")));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF013746), foregroundColor: Colors.white),
                child: Text("Simpan"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Hapus Topik?"),
        content: Text("Yakin ingin menghapus topik ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Batal")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              bool success = await Provider.of<ForumProvider>(context, listen: false).deleteForum(widget.forum.id);
              if (success) {
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Topik dihapus")));
              }
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _sendComment() async {
    if (_commentController.text.isEmpty) return;
    if (_currentUserId == null) return;

    bool success = await Provider.of<ForumProvider>(context, listen: false)
        .postComment(widget.forum.id, _currentUserId!, _commentController.text);

    if (success) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
      _loadComments(); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Komentar terkirim!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMyTopic = widget.forum.userId == _currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Diskusi"),
        backgroundColor: Color(0xFF013746),
        foregroundColor: Colors.white,
        actions: [
          if (isMyTopic) ...[
            IconButton(
              icon: Icon(Icons.edit, color: Colors.yellowAccent),
              onPressed: _showEditDialog,
              tooltip: "Edit",
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _confirmDelete,
              tooltip: "Hapus",
            ),
          ]
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(backgroundImage: NetworkImage(widget.forum.fotoProfilUrl)),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.forum.namaPenulis, style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(widget.forum.createdAt, style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(widget.forum.judul, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(widget.forum.deskripsi, style: TextStyle(fontSize: 16, height: 1.5)),
                        
                        // GAMBAR TOPIK (DISESUAIKAN)
                        if (widget.forum.gambarUrl != null)
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(widget.forum.gambarUrl!),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(thickness: 8, color: Colors.grey[100]),
                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Text("Komentar (${_comments.length})", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),

                  _isLoading 
                    ? Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())) 
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final com = _comments[index];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(com['foto_profil_url']),
                                  radius: 18,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(com['nama'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                          SizedBox(width: 8),
                                          Text(com['created_at'], style: TextStyle(fontSize: 10, color: Colors.grey)),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(com['konten'], style: TextStyle(color: Colors.black87, fontSize: 14)),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _handleReply(com['nama']),
                                        child: Text("Balas", style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  SizedBox(height: 80), 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -2))],
        ),
        child: SafeArea( 
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _inputFocusNode, 
                  decoration: InputDecoration(
                    hintText: "Tambahkan komentar...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.send, color: Color(0xFF013746)), onPressed: _sendComment),
            ],
          ),
        ),
      ),
    );
  }
}