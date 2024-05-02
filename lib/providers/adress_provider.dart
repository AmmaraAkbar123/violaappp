
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class AddressProvider with ChangeNotifier {
  String _currentAddress = 'Fetching address...';

  String get currentAddress => _currentAddress;

  Future<void> determineAndSetCurrentAddress() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentAddress = 'Location services are disabled.';
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          _currentAddress = 'Location permissions are denied.';
          notifyListeners();
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      _currentAddress = "Failed to get address: $e";
    }
    notifyListeners();
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      _currentAddress =
          "${place.street}, ${place.locality}, ${place.country}";
    } else {
      _currentAddress = "No address found";
    }
  } catch (e) {
    print(e);
    _currentAddress = "Failed to get address: $e";
  }
  notifyListeners(); // Ensure listeners are notified after updating the address
}


  //for city name

  Future<String> getCurrentCityName() async {
    String cityName = "Fetching city name...";
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return 'Location permissions are denied.';
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      cityName = await _getCityNameFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      cityName = "Failed to get city name: $e";
    }
    return cityName;
  }

  Future<String> _getCityNameFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;
      return place.locality ?? "City not found";
    } catch (e) {
      print(e);
      return "Failed to get city name: $e";
    }
  }
}