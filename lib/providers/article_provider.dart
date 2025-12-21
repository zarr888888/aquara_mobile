import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import '../services/auth_service.dart'; 

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  // Fungsi Ambil Data (GET)
  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Panggil API get_articles.php
      final url = Uri.parse('${AuthService.baseUrl}/get_articles.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _articles = data.map((json) => Article.fromJson(json)).toList();
      } else {
        print("Gagal ambil data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Koneksi: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}