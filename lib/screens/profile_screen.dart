import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart'; 
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String userId = "";
  String userFotoUrl = "";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
      _namaController.text = prefs.getString('userName') ?? "";
      _emailController.text = prefs.getString('userEmail') ?? "";
      userFotoUrl = prefs.getString('userFoto') ?? "";
    });
  }

  // Fungsi Pilih Gambar dari Galeri
  Future _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi Simpan Data ke API
  Future _updateProfile() async {
    setState(() => _isLoading = true);
    
    try {
      var request = http.MultipartRequest('POST', Uri.parse("${AuthService.baseUrl}/update_profile.php"));
      request.fields['id'] = userId;
      request.fields['nama'] = _namaController.text;
      request.fields['email'] = _emailController.text;
      request.fields['password'] = _passwordController.text;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', _imageFile!.path));
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse); // Baca respon server

      if (response.statusCode == 200) {
        var data = json.decode(response.body); // Parse JSON dari PHP

        if (data['status'] == 'success') {
          // Update Shared Preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', _namaController.text);
          await prefs.setString('userEmail', _emailController.text);
          
          // PERBAIKAN 1: SIMPAN URL FOTO BARU
          if (data['foto_url'] != null) {
             await prefs.setString('userFoto', data['foto_url']); 
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profil Berhasil Diupdate!")));
          
          // PERBAIKAN 2: OTOMATIS KEMBALI KE HOME
          // Beri jeda sedikit biar user sempat baca notif, lalu keluar
          await Future.delayed(Duration(seconds: 1)); 
          Navigator.pop(context); 
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'] ?? "Gagal Update")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Server")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Terjadi kesalahan koneksi")));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profil"), backgroundColor: Color(0xFF013746)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!) // Foto baru yang dipilih
                    : (userFotoUrl.isNotEmpty 
                        ? NetworkImage(userFotoUrl) // Foto lama dari DB
                        : AssetImage('assets/images/default.png')) as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, size: 20, color: Color(0xFF013746)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(controller: _namaController, decoration: InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder())),
            SizedBox(height: 20),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            SizedBox(height: 20),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password Baru (Opsional)", border: OutlineInputBorder())),
            SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3F8686)),
                onPressed: _isLoading ? null : _updateProfile,
                child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text("SIMPAN PERUBAHAN"),
              ),
            )
          ],
        ),
      ),
    );
  }
}