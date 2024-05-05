import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  late GoogleMapController mapController;
  final TextEditingController searchController = TextEditingController();
  String currentAddress = 'Fetching address...';
  Set<Marker> markers = {};
  LatLng lastMapPosition = LatLng(31.473427, 74.266420); // Default coordinates
  List<String> suggestions = [];
  bool showSuggestions = false;
  String apiKey =
      'AIzaSyAL4OhK2DnU0XMcj0VZgwfc4DKRKLdOdv0'; // Store this securely
  bool showCard = true;

  // Initialize default position
  final CameraPosition defaultPosition = CameraPosition(
    target: LatLng(31.473427, 74.266420),
    zoom: 14,
  );

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    determineCurrentPosition();
  }

  // Start Determine Current Position
  Future<void> determineCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      currentAddress = 'Location services are disabled.';
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        currentAddress = 'Location permissions are denied';
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      currentAddress =
          'Location permissions are permanently denied, we cannot request permissions.';
      notifyListeners();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    updateCameraPosition(position.latitude, position.longitude);
    updateAddressAndMarker(position.latitude, position.longitude);
  }
  // End Determine Current Position

  // Start Update Address and Marker
  void updateAddressAndMarker(double latitude, double longitude) async {
    LatLng newPosition = LatLng(latitude, longitude);
    try {
      String address = await getAddressFromLatLng(latitude, longitude);
      currentAddress = address;
    } catch (e) {
      currentAddress = "Failed to get address: ${e.toString()}";
    }
    updateMarkers(newPosition);
  }
  // End Update Address and Marker

  //Start Update Marker
  void updateMarkers(LatLng newPosition, [String? infoTitle]) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId("currentLocation"),
        position: newPosition,
        infoWindow: InfoWindow(title: infoTitle ?? currentAddress),
      ),
    );
    notifyListeners();
  }
  //End Update Marker

  //Start Get Address from Coordinates
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
  //End Get Address from Coordinates

  //Start Remove Card when Camera Move
  void onCameraMoveStarted() {
    showCard = false;
    notifyListeners();
  }
  //End Remove Card when Camera Move

  //Start When Camera is not Moving
  void onCameraIdle() {
    showCard = true;
    updateAddressAndMarker(lastMapPosition.latitude, lastMapPosition.longitude);
  }
  //End When Camera is not Moving

  //Start When Camera is on Move
  void onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
    updateMarkers(lastMapPosition);
  }
  //End When Camera is on Move

  //Start Update Camera Position
  void updateCameraPosition(double latitude, double longitude) {
    LatLng newPosition = LatLng(latitude, longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
    lastMapPosition = newPosition;
    updateMarkers(newPosition, "Updating location...");
  }
  //End Update Camera Position

  //Start Set Marker on Tap
  void handleTap(LatLng tappedPoint) async {
    updateCameraPosition(tappedPoint.latitude, tappedPoint.longitude);
    updateAddressAndMarker(tappedPoint.latitude, tappedPoint.longitude);
  }
  //End Set Marker on Tap

  // Start Get Address from Coordinates
  Future<String> _getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String street = place.street ?? 'Street unknown';
        String locality = place.locality ?? 'City unknown';
        String country = place.country ?? 'Country unknown';
        return "$street, $locality, $country";
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Failed to get address: ${e.toString()}";
    }
  }
  // End Get Address from Coordinates

  // Start Get Place Details
  Future<LatLng> fetchPlaceDetails(String placeId, String apiKey) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';
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
        throw Exception('Failed to fetch place details');
      }
    } catch (e) {
      throw Exception('Failed to fetch place details: $e');
    }
  }
  // End Get Place Details

  // Start Suggestions
  Future<List<String>> fetchSuggestions(String input, String apiKey) async {
    final String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(request));
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
  // End Suggestions

  //Start Changes made on Search Suggestions
  Future<void> onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      suggestions = await fetchSuggestions(query, apiKey);
      showSuggestions = true;
    } else {
      suggestions = [];
      showSuggestions = false;
    }
    notifyListeners();
  }
  //End Changes made on Search Suggestions

  // Start Search and Navigation
  void searchAndNavigate(String query) {
    if (query.isNotEmpty) {
      fetchPlaceDetails(query, apiKey).then((latLng) {
        updateCameraPosition(latLng.latitude, latLng.longitude);
        markers.clear();
        markers.add(
          Marker(
            markerId: MarkerId('searchedLocation'),
            position: latLng,
            infoWindow: InfoWindow(title: query),
          ),
        );
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
  // End Search and Navigation

  //Start Selection of Suggestion
  void selectSuggestion(String suggestion) {
    searchController.text = suggestion;
    showSuggestions = false;
    searchAndNavigate(suggestion);
    notifyListeners();
  }
  //End Selection of Suggestion
}
