import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class EventProvider with ChangeNotifier {
  // GANTI IP SESUAI LAPTOP
  final String baseUrl = "http://192.168.43.63:8080/aquara/api"; 

  List<EventModel> _events = [];
  bool _isLoading = false;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$baseUrl/get_events.php"));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _events = data.map((item) => EventModel.fromJson(item)).toList();
      } else {
        print("Gagal fetch events: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetch events: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}