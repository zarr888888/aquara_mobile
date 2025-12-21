import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // URL API
  static const String baseUrl = "http://192.168.43.63:8080/aquara/api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login.php');
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal koneksi ke server');
    }
  }
}