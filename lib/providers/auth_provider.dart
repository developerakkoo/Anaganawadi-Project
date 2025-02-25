import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void login(String email, String password) {
    _isLoading = true;
    notifyListeners();

    // Simulating HTTP Request with a Delay
    Future.delayed(Duration(seconds: 2), () {
      _isLoading = false;
      notifyListeners();
      print("Login Successful!");
      print(email);
      print(password);

      let object = {
        email:email,
        password:password

      };

      print(object);
    });
  }
}
