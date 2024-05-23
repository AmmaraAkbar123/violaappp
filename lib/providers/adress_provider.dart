import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:viola/providers/user_provider.dart';

class AddressProvider with ChangeNotifier {
  final String _currentCityName = 'Finding city name...';

  String get currentCityName => _currentCityName;

//start add adresss in adress selection screen
  int? _selectedOption;
  List<LocationData> _locations = [];

  int? get selectedOption => _selectedOption;
  List<LocationData> get locations => _locations;

  void setSelectedOption(int? option) {
    _selectedOption = option;
    notifyListeners();
  }

  Future<void> fetchLocations(UserProvider userProvider) async {
    // Load locations specific to the current user
    await userProvider.loadLocationsFromPrefs();
    _locations = userProvider.savedLocations;
    notifyListeners();
  }

// end add adresss in adress selection screen

//start get current city name in signuPpage
  Future<String> getCurrentCityName() async {
    try {
      Position position = await _determinePosition();
      return await _getCityNameFromLatLng(
          position.latitude, position.longitude);
    } catch (e) {
      return "Failed to get city name: $e";
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permissions are denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> _getCityNameFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;
      return place.locality ?? "City not found";
    } catch (e) {
      throw Exception("Failed to get city name: $e");
    }
  }
}
