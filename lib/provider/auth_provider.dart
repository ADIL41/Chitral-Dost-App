import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // user state

  String? _userid;
  String? _userEmail;
  String? _userName;

  //loading and error state

  final bool _isLoading = false;
  final bool _isLoggedIn = false;
  String? _errormessage;

  //getters

  String? get userid => _userid;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errormessage;
}
