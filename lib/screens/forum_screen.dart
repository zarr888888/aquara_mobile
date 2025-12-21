import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/forum_provider.dart';
import 'add_forum_screen.dart';
import 'forum_detail_screen.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId');
    });

    if (_currentUserId != null) {
      Provider.of<ForumProvider>(context, listen: false).fetchForums(_currentUserId!);
    }
  }

  // Fungsi Hapus dengan Konfirmasi
  void _confirmDelete(String topicId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Hapus Topik?"),
        content: Text("Topik ini akan dihapus permanen."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Batal")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              bool success = await Provider.of<ForumProvider>(context, listen: false).deleteForum(topicId);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Topik dihapus")));
              }
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum Diskusi"),
        backgroundColor: Color(0xFF013746),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF013746),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
           await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddForumScreen()),
          );
          if (_currentUserId != null) {
             Provider.of<ForumProvider>(context, listen: false).fetchForums(_currentUserId!);
          }
        },
      ),

      body: Consumer<ForumProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.forums.isEmpty) {
            return Center(child: Text("Belum ada diskusi."));
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: provider.forums.length,
            itemBuilder: (context, index) {
              final forum = provider.forums[index];
              bool isMyTopic = forum.userId == _currentUserId; // Cek Milik Sendiri
              
              return Card(
                margin: EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForumDetailScreen(forum: forum)),
                    ).then((_) {
                       if (_currentUserId != null) provider.fetchForums(_currentUserId!);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Profil + Tombol Hapus (Jika punya sendiri)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(forum.fotoProfilUrl),
                              radius: 20,
                              onBackgroundImageError: (_,__) => Icon(Icons.person),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(forum.namaPenulis, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(forum.createdAt, style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                            ),
                            // TOMBOL HAPUS (HANYA UNTUK PEMILIK)
                            if (isMyTopic)
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                                onPressed: () => _confirmDelete(forum.id),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                          ],
                        ),
                        SizedBox(height: 10),

                        // Konten
                        Text(forum.judul, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 5),
                        Text(forum.deskripsi, maxLines: 3, overflow: TextOverflow.ellipsis),
                        
                        if (forum.gambarUrl != null)
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(forum.gambarUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          
                        SizedBox(height: 15),
                        Divider(),
                        
                        // Footer Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFooterBtn(
                              icon: forum.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                              color: forum.isLikedByMe ? Colors.red : Colors.grey,
                              label: "${forum.totalLikes} Suka",
                              onTap: () {
                                if (_currentUserId != null) provider.toggleLike(forum.id, _currentUserId!);
                              },
                            ),
                            _buildFooterBtn(
                              icon: Icons.comment_outlined, 
                              color: Colors.grey,
                              label: "${forum.totalKomentar} Komentar",
                              onTap: () {
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForumDetailScreen(forum: forum)),
                                );
                              }
                            ),
                            _buildFooterBtn(
                              icon: Icons.share, 
                              color: Colors.grey,
                              label: "Bagikan",
                              onTap: () {
                                Share.share("Cek diskusi ini: ${forum.judul}");
                              }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFooterBtn({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: 5),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}