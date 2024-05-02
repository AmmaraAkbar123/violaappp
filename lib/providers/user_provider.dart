import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:viola/services/authentication_service.dart';
import 'package:viola/services/shared_preff/shared_pref.dart';

class User {
  String name;
  bool isLoggedIn;

  User({this.name = '', this.isLoggedIn = false});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        isLoggedIn: json['isLoggedIn'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'isLoggedIn': isLoggedIn,
      };
}

class UserProvider with ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  final PreferencesService _prefsService = PreferencesService();  // Single instance
  User _user = User();
  User get user => _user;

  UserProvider() {
    loadUserFromPrefs();
    checkLoginStatus();
  }
  
  Future<void> checkLoginStatus() async {
    String? token = await _authService.loadToken();
    if (token != null) {
      // Assume token is still valid, or add a validation check here
      _user.isLoggedIn = true;
    } else {
      _user.isLoggedIn = false;
    }
    notifyListeners();
  }

  void login(String name, String token) async {
    _user.name = name;
    _user.isLoggedIn = true;
    await _authService.saveToken(token);  // Save the token
    await saveUserToPrefs();  // Save other user details to prefs
    notifyListeners();
  }

  void logout() async {
    await _authService.clearToken();  
    _user = User();  // Reset user to its default state
    await clearUserFromPrefs();  // Optionally clear other persisted user details
    notifyListeners();
}


  Future<void> saveUserToPrefs() async {
    String userJson = json.encode(_user.toJson());
    await _prefsService.save('user', userJson);
  }

  Future<void> loadUserFromPrefs() async {
    String? userJson = await _prefsService.load('user');
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
      notifyListeners();
    }
  }

  Future<void> clearUserFromPrefs() async {
    await _prefsService.remove('user');
  }
}