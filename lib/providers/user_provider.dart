import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:viola/services/api_services/authentication_service.dart';
import 'package:viola/services/shared_preff/shared_preferences.dart';

class User {
  String name;
  bool isLoggedIn;
  bool isOTPVerified; // Track OTP verification status

  User({this.name = '', this.isLoggedIn = false, this.isOTPVerified = false});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        isLoggedIn: json['isLoggedIn'],
        isOTPVerified: json['isOTPVerified'] ?? false, // Handle null case
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'isLoggedIn': isLoggedIn,
        'isOTPVerified': isOTPVerified,
      };
}

class UserProvider with ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  final PreferencesService _prefsService = PreferencesService();
  User _user = User();
  User get user => _user;

  UserProvider() {
    loadUserFromPrefs();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? token = await _authService.loadToken();
    if (token != null && _user.isOTPVerified) {
      _user.isLoggedIn = true;
    } else {
      _user.isLoggedIn = false;
    }
    notifyListeners();
  }

  void login(String name, String token) async {
    _user.name = name;
    _user.isLoggedIn = true;
    await _authService.saveToken(token);
    await saveUserToPrefs();
    notifyListeners();
  }

  void verifyOTP() {
    _user.isOTPVerified = true;
    saveUserToPrefs(); // Save the updated OTP verification status
    notifyListeners();
  }

  void updateUserAfterOTP(String name, {String token = ''}) {
    _user.name = name;
    _user.isOTPVerified = true;
    _user.isLoggedIn = token.isNotEmpty;
    if (token.isNotEmpty) {
      _authService.saveToken(token); // Save token if provided
    }
    saveUserToPrefs(); // Persist user data
    notifyListeners();
  }

  void logout() async {
    await _authService.clearToken();
    _user = User(); // Reset user to default state
    await clearUserFromPrefs();
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
