import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Mock user data
  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Add your sign-in logic here
      _user = {'email': email};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Add your sign-up logic here
      _user = {'email': email, 'name': name};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Add your Google sign-in logic here
      _user = {'email': 'google@example.com'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Add your sign-out logic here
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

