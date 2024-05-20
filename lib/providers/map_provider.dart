import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viola/auth/api_constant.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/providers/user_provider.dart';

class MapProvider extends ChangeNotifier {
  GoogleMapController? mapController; // Updated to nullable type
  final TextEditingController searchController = TextEditingController();
  String currentAddress = 'Finding address...';
  Set<Marker> markers = {};
  LatLng lastMapPosition = const LatLng(31.473427, 74.266420);
  List<String> suggestions = [];
  bool showSuggestions = false;
  bool showCard = true;
  Mydata? homepageData;
  String apiKey =
      'AIzaSyAL4OhK2DnU0XMcj0VZgwfc4DKRKLdOdv0'; // Store this securely
  bool _isPositionFetched = false;

  LatLng get currentLatLng => lastMapPosition;

  // Method to update the camera position based on an address
  Future<void> navigateToAddress(LatLng latLng) async {
    await updateCameraPosition(latLng.latitude, latLng.longitude);
    await updateAddressAndMarker(latLng.latitude, latLng.longitude);
  }

  // to save location in address selection screen
  void saveCurrentLocation(UserProvider userProvider, {bool forceSave = true}) {
    if (forceSave) {
      userProvider.addLocation(currentAddress, lastMapPosition);
    }
  }

  // Debouncer for search input to limit API calls
  final debounce =
      Debouncer<String>(const Duration(milliseconds: 500), initialValue: '');

  final CameraPosition defaultPosition = const CameraPosition(
    target: LatLng(31.473427, 74.266420),
    zoom: 14,
  );

  MapProvider() {
    // Set up the debounce callback
    debounce.values.listen((query) {
      fetchSuggestions(query, apiKey).then((newSuggestions) {
        suggestions = newSuggestions;
        showSuggestions = true;
        notifyListeners();
      }).catchError((e) {
        print("Error fetching suggestions: $e");
      });
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    determineCurrentPosition(); // Ensure this is called after mapController is initialized
  }

  void resetPositionFetched() {
    _isPositionFetched = false;
  }

  Future<void> determineCurrentPosition() async {
    if (_isPositionFetched) {
      // Position already fetched, no need to fetch again
      return;
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentAddress = 'Location services are disabled.';
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Location permission denied, request it again
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Location permission denied again, navigate to app settings
          openLocationSettings();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentAddress =
            'Location permissions are permanently denied, we cannot request permissions.';
        notifyListeners();
        return;
      }

      // Map is ready, fetch current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await updateCameraPosition(position.latitude, position.longitude);
      await updateAddressAndMarker(position.latitude, position.longitude);
      _isPositionFetched = true; // Update flag
    } catch (e) {
      print('Error fetching location: $e');
      currentAddress = 'Error fetching location: $e';
      notifyListeners();
    }
  }

// on deny redirect the user to setting for permission
  void openLocationSettings() {
    openAppSettings().then((_) {
      print('Opened app settings');
    }).catchError((error) {
      print('Error opening app settings: $error');
    });
  }

  Future<void> updateAddressAndMarker(double latitude, double longitude) async {
    LatLng newPosition = LatLng(latitude, longitude);
    lastMapPosition = newPosition;

    try {
      String address = await getAddressFromLatLng(latitude, longitude);
      currentAddress = address;
      markers = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: newPosition,
          infoWindow: InfoWindow(title: 'Current Location', snippet: address),
        ),
      };
    } catch (e) {
      currentAddress = "Failed to get address: ${e.toString()}";
    }

    notifyListeners();
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.country}";
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Failed to get address: ${e.toString()}";
    }
  }

  void onCameraMoveStarted() {
    showCard = false;
    notifyListeners();
  }

  void onCameraIdle() {
    updateAddressAndMarker(lastMapPosition.latitude, lastMapPosition.longitude);
    showCard = true;
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
    notifyListeners();
  }

  Future<void> updateCameraPosition(double latitude, double longitude) async {
    LatLng newPosition = LatLng(latitude, longitude);
    if (newPosition != lastMapPosition) {
      lastMapPosition = newPosition;
      notifyListeners();
    }
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(newPosition));
    }
  }

  void handleTap(LatLng tappedPoint) async {
    await updateCameraPosition(tappedPoint.latitude, tappedPoint.longitude);
    await updateAddressAndMarker(tappedPoint.latitude, tappedPoint.longitude);
    lastMapPosition = tappedPoint;
    notifyListeners();
  }

  void onLocationSelected(
      LatLng selectedLocation, Function updateLocationCallback) {
    lastMapPosition = selectedLocation;
    updateLocationCallback(
        selectedLocation); // Pass the selectedLocation to the callback
    // Do not update the current address here
    notifyListeners();
  }

  Future<LatLng> fetchPlaceDetails(String placeId, String apiKey) async {
    final String url =
        '${ApiConstants.googlePlaceDetailsUrl}?placeid=$placeId&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          final location = result['result']['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
        throw Exception(result['error_message']);
      } else {
        throw Exception('Failed to find place details');
      }
    } catch (e) {
      throw Exception('Failed to find place details: $e');
    }
  }

  Future<List<String>> fetchSuggestions(String input, String apiKey) async {
    final String url =
        '${ApiConstants.googlePlaceAutocompleteUrl}?input=$input&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          return (result['predictions'] as List)
              .map<String>((p) => p['description'] as String)
              .toList();
        }
        if (result['status'] == 'ZERO_RESULTS') {
          return [];
        }
        throw Exception(result['error_message']);
      } else {
        throw Exception('Failed to fetch suggestions');
      }
    } catch (e) {
      throw Exception('Failed to fetch suggestions: $e');
    }
  }

  void onSearchChanged(String query) {
    debounce.setValue(query);
  }

  void searchAndNavigate(String query) {
    if (query.isNotEmpty) {
      fetchPlaceDetails(query, apiKey).then((latLng) {
        updateCameraPosition(latLng.latitude, latLng.longitude);
        getAddressFromLatLng(latLng.latitude, latLng.longitude).then((address) {
          currentAddress = address;
          notifyListeners();
        }).catchError((e) {
          print("Error getting address: $e");
          currentAddress = "Failed to get address";
          notifyListeners();
        });
      }).catchError((e) {
        print("Search Error: $e");
      });
    }
  }

  void selectSuggestion(String suggestion) {
    searchController.text = suggestion;
    showSuggestions = false;
    searchAndNavigate(suggestion);
    notifyListeners();
  }
}
