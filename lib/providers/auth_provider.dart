import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> login(String name, String password) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://192.168.208.246:8080/api/auth/login'); // Replace with your API endpoint
    final body = json.encode({
      'userName': name,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Successful login
        final responseData = json.decode(response.body);
        print('Login successful: $responseData');
        _errorMessage = '';
      } else {
        // Handle errors
        final responseData = json.decode(response.body);
        _errorMessage = responseData['message'] ?? 'Login failed';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}