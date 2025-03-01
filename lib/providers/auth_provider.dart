import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void login(String email, String password) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(Duration(seconds: 2), () {
      _isLoading = false;
      notifyListeners();

      Map<String, String> object = {
        "E-mail": email,
        "Password": password,
      };

      print(object); 

    });
  }
}
