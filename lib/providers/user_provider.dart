import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viola/services/api_services/authentication_service.dart';
import 'package:viola/services/shared_preff/shared_preferences.dart';

class User {
  String name;
  int userId;
  bool isLoggedIn;
  bool isOTPVerified; // Track OTP verification status

  User(
      {this.name = '',
      this.isLoggedIn = false,
      this.userId = 0,
      this.isOTPVerified = false});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        userId: json['userId'],
        isLoggedIn: json['isLoggedIn'],
        isOTPVerified: json['isOTPVerified'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'userId': userId,
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
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    await loadUserFromPrefs(); // Make sure this loads the user info first
    await checkLoginStatus(); // Then check the token validity
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

  void login(String name, int userId, String token) async {
    _user.name = name;
    _user.userId = userId; // Make sure to set the userId here.
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

  void updateUserAfterOTP(String name, int userId, String token) {
    _user.name = name;
    _user.userId = userId;
    _user.isOTPVerified = true;
    _user.isLoggedIn = token.isNotEmpty;
    if (token.isNotEmpty) {
      _authService.saveToken(token);
    }
    saveUserToPrefs();
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
    print('Saving User: $userJson'); // Debug statement
    await _prefsService.save('user', userJson);
  }

  Future<void> loadUserFromPrefs() async {
    String? userJson = await _prefsService.load('user');
    print('Loaded User JSON: $userJson'); // Debug statement
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
      notifyListeners();
    }
    await checkLoginStatus();
  }

  Future<void> clearUserFromPrefs() async {
    await _prefsService.remove('user');
  }

  // to save location in address selection screen
  List<LocationData> _savedLocations = [];

  List<LocationData> get savedLocations => _savedLocations;

  void addLocation(String name, LatLng position) {
    _savedLocations.add(LocationData(name: name, position: position));
    saveLocationsToPrefs();
    notifyListeners();
  }

  void removeLocation(int index) {
    _savedLocations.removeAt(index);
    saveLocationsToPrefs();
    notifyListeners();
  }

  Future<void> saveLocationsToPrefs() async {
    List<String> locationsJson = _savedLocations
        .map((location) => json.encode(location.toJson()))
        .toList();
    await _prefsService.save('locations', json.encode(locationsJson));
  }

  Future<void> loadLocationsFromPrefs() async {
    String? locationsJson = await _prefsService.load('locations');
    if (locationsJson != null) {
      List<dynamic> locationsList = json.decode(locationsJson);
      _savedLocations = locationsList
          .map((location) => LocationData.fromJson(json.decode(location)))
          .toList();
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getLocations(String userId) async {
    await loadLocationsFromPrefs(); // Ensure locations are loaded from prefs
    return _savedLocations.map((location) {
      return {
        'name': location.name,
        'latLng': location.position,
      };
    }).toList();
  }
}

class LocationData {
  final String name;
  final LatLng position;

  LocationData({required this.name, required this.position});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      name: json['name'],
      position: LatLng(json['latitude'], json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }
}
