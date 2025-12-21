import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/forum_model.dart';

class ForumProvider with ChangeNotifier {
  //GANTI IP DI SINI SESUAI LAPTOP
  final String baseUrl = "http://192.168.43.63:8080/aquara/api"; 

  List<ForumModel> _forums = [];
  bool _isLoading = false;

  List<ForumModel> get forums => _forums;
  bool get isLoading => _isLoading;

  // 1. AMBIL DATA FORUM (GET)
  Future<void> fetchForums(String currentUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$baseUrl/get_forums.php?user_id=$currentUserId"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _forums = data.map((item) => ForumModel.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error fetch: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. TOGGLE LIKE
  Future<void> toggleLike(String topicId, String userId) async {
    final index = _forums.indexWhere((f) => f.id == topicId);
    if (index == -1) return;

    bool oldStatus = _forums[index].isLikedByMe;
    _forums[index].isLikedByMe = !oldStatus;
    _forums[index].totalLikes += oldStatus ? -1 : 1;
    notifyListeners(); 

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/like_topic.php"),
        body: {'topic_id': topicId, 'user_id': userId}
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
           _forums[index].totalLikes = int.parse(data['total_likes'].toString());
           notifyListeners();
        }
      }
    } catch (e) {
      _forums[index].isLikedByMe = oldStatus;
      _forums[index].totalLikes += oldStatus ? 1 : -1;
      notifyListeners();
    }
  }

  // 3. TAMBAH FORUM BARU
  Future<bool> addForum(String userId, String judul, String deskripsi, File? imageFile) async {
    final url = Uri.parse("$baseUrl/create_forum.php");
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['user_id'] = userId;
      request.fields['judul'] = judul;
      request.fields['deskripsi'] = deskripsi;

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('gambar', imageFile.path));
      }

      var response = await request.send();
      if (response.statusCode == 201) {
        await fetchForums(userId); 
        return true;
      } 
    } catch (e) {
      return false;
    }
    return false;
  }

  // 4. HAPUS FORUM
  Future<bool> deleteForum(String id) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/delete_forum.php"), body: {'id': id});
      if (response.statusCode == 200) {
        _forums.removeWhere((f) => f.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) { print("Error delete: $e"); }
    return false;
  }

  // 5. EDIT FORUM (UPDATE: SUPPORT GAMBAR)
  Future<bool> updateForum(String id, String judul, String deskripsi, File? newImage) async {
    final url = Uri.parse("$baseUrl/update_forum.php");
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['id'] = id;
      request.fields['judul'] = judul;
      request.fields['deskripsi'] = deskripsi;

      // Jika ada gambar baru, kirim. Jika null, server akan pakai gambar lama.
      if (newImage != null) {
        request.files.add(await http.MultipartFile.fromPath('gambar', newImage.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // Karena gambar mungkin berubah, kita harus refresh data dari server 
        // agar URL gambar di aplikasi terupdate. Kita tidak bisa sekedar ubah data lokal.
        // Tapi sementara kita update teksnya dulu biar cepat.
        int index = _forums.indexWhere((f) => f.id == id);
        if (index != -1) {
          _forums[index].judul = judul;
          _forums[index].deskripsi = deskripsi;
          notifyListeners();
        }
        return true;
      }
    } catch (e) { print("Error update: $e"); }
    return false;
  }

  // KOMENTAR
  Future<List<dynamic>> fetchComments(String topicId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_comments.php?topic_id=$topicId"));
      if (response.statusCode == 200) return json.decode(response.body);
    } catch (e) { print("Error fetch comments: $e"); }
    return [];
  }

  Future<bool> postComment(String topicId, String userId, String konten) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/add_comment.php"),
        body: {'topic_id': topicId, 'user_id': userId, 'konten': konten}
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
            final index = _forums.indexWhere((f) => f.id == topicId);
            if (index != -1) {
              _forums[index].totalKomentar += 1; 
              notifyListeners(); 
            }
            return true;
        }
      }
    } catch (e) { print("Error post comment: $e"); }
    return false;
  }
}