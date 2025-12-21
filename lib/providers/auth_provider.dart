import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); 

    try {
      final response = await AuthService().login(email, password);
      
      if (response['success']) {
        _user = User.fromJson(response['data']);
        
        // Simpan sesi ke Shared Preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('userId', _user!.id);
        await prefs.setString('userName', _user!.nama);
        await prefs.setString('userEmail', _user!.email);
        await prefs.setString('userFoto', _user!.fotoUrl);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}