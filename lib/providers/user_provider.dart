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

  User({
    this.name = '',
    this.isLoggedIn = false,
    this.userId = 0,
    this.isOTPVerified = false,
  });

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

  List<LocationData> _savedLocations = [];

  UserProvider() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    await loadUserFromPrefs();
    await checkLoginStatus();
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
    _user.userId = userId;
    _user.isLoggedIn = true;
    await _authService.saveToken(token);
    await saveUserToPrefs();
    await loadLocationsFromPrefs();
    notifyListeners();
  }

  void verifyOTP() {
    _user.isOTPVerified = true;
    saveUserToPrefs();
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
    loadLocationsFromPrefs();
    notifyListeners();
  }

  void logout() async {
    await _authService.clearToken();
    _user = User();
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
    await checkLoginStatus();
    await loadLocationsFromPrefs();
  }

  List<LocationData> get savedLocations => _savedLocations;
  void addLocation(String name, LatLng position) {
    // Check if the location is already saved
    bool isDuplicate = _savedLocations.any((location) =>
        location.name == name &&
        location.position.latitude == position.latitude &&
        location.position.longitude == position.longitude);

    if (!isDuplicate) {
      _savedLocations.add(LocationData(name: name, position: position));
      saveLocationsToPrefs();
      notifyListeners();
    }
  }

  Future<void> saveLocationsToPrefs() async {
    if (_user.userId == 0) return; // Ensure userId is valid

    List<String> locationsJson = _savedLocations
        .map((location) => json.encode(location.toJson()))
        .toList();
    await _prefsService.save('locations_${_user.userId}',
        json.encode(locationsJson)); // Include user ID in the key
  }

  Future<void> loadLocationsFromPrefs() async {
    if (_user.userId == 0) return; // Ensure userId is valid

    String? locationsJson = await _prefsService
        .load('locations_${_user.userId}'); // Include user ID in the key
    if (locationsJson != null) {
      try {
        List<dynamic> locationsList = json.decode(locationsJson);
        _savedLocations = locationsList
            .map((location) => LocationData.fromJson(location))
            .toList();
        notifyListeners();
      } catch (e) {
        print('Error decoding locations JSON: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    await loadLocationsFromPrefs();
    return _savedLocations.map((location) {
      return {
        'name': location.name,
        'latitude': location.position.latitude,
        'longitude': location.position.longitude,
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
      position: LatLng(json['latitude'] as double, json['longitude'] as double),
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
