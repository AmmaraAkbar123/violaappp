import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:viola/json_models/category_model.dart';
import 'package:viola/json_models/feature_model.dart';



class FeatureDataProvider extends ChangeNotifier{

   late Future<Featured> _featureData;
    Future<Featured> get featureData=> _featureData;

    FeatureDataProvider() {
    _featureData = getDataApi();
  }

  Future<Featured> getDataApi() async {
    try {
      final response = await http.get(Uri.parse("http://dev.viola.myignite.online/api/salon_feature?api_token&myLat=31.4734661&myLon=74.2665947"));

      if (response.statusCode == 200) {
        // Parse the JSON response
        var jsonData = jsonDecode(response.body);

        // Create a Featured object from the parsed JSON
        Featured featured = Featured.fromJson(jsonData);

        // Return the Featured object
        return featured;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  List<bool> _selectedCategories = [];

  List<Category> get categories => _categories;
  List<bool> get selectedCategories => _selectedCategories;

  CategoryProvider() {
    loadCategories();
  }

 void toggleCategorySelection(int index, bool? isSelected) {
    if (isSelected != null && index < _selectedCategories.length) {
      _selectedCategories[index] = isSelected;
      notifyListeners();
    }
  }
final String _baseUrl = 'http://dev.viola.myignite.online/api/categories';

  Future<void> loadCategories() async {
    var categories = await fetchCategories();
    _categories = categories;
    _selectedCategories = List<bool>.filled(categories.length, false);
    notifyListeners();  // Notify listeners to update the UI after data is fetched and state is updated
  }

  Future<List<Category>> fetchCategories() async {
    Uri uri = Uri.parse('$_baseUrl?parent=true&orderBy=order&sortBy=asc');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        }
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        if (responseJson['success']) {
          List<dynamic> categoryJsonList = responseJson['data'];
          return categoryJsonList.map((json) => Category.fromJson(json)).toList();
        } else {
          throw Exception('Failed to find categories in the response');
        }
      } else {
        throw Exception('Failed to load categories: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }
}

class MapProvider extends ChangeNotifier {

late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  String _currentAddress = 'Fetching address...';
  Set<Marker> _markers = {};
  List<String> suggestions = [];
  bool showSuggestions = false;
  bool _showCard = true;

  // Getters for the private fields
  GoogleMapController get mapController => _mapController;
  TextEditingController get searchController => _searchController;
  String get currentAddress => _currentAddress;
  Set<Marker> get markers => _markers;
  
  bool get showCard => _showCard;

  CameraPosition defaultPosition = const CameraPosition(
    target: LatLng(31.473427, 74.266420), // Default to a location
    zoom: 14,
  );
  late LatLng lastMapPosition = defaultPosition.target;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    determineCurrentPosition();
  }

  Future<void> determineCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _currentAddress='Location services are disabled.';
      notifyListeners();
      return;
      
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _currentAddress= 'Location permissions are denied';
        notifyListeners();
        return;
        
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _currentAddress= 'Location permissions are permanently denied, we cannot request permissions.';
      notifyListeners();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    updateCameraPosition(position.latitude, position.longitude);
  }

  void onCameraMoveStarted() {
    _showCard = false;
    notifyListeners();
  }

  void onCameraIdle() {
    getAddressFromLatLng(lastMapPosition.latitude, lastMapPosition.longitude)
        .then((address) {
      _showCard = true;
      _currentAddress = address;
      _markers = {
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: lastMapPosition,
          infoWindow: InfoWindow(title: currentAddress),
        ),
      };
      notifyListeners();
    }).catchError((error) {
      print("Error fetching address: $error");
      _currentAddress = "Failed to get address";
      notifyListeners();
    });
  }

  void onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
    _markers = {
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: lastMapPosition,
      ),
    };
    notifyListeners();
  }

  void updateCameraPosition(double latitude, double longitude) {
    _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String street = place.street ?? 'Street unknown';
        String locality = place.locality ?? 'City unknown';
        String country = place.country ?? 'Country unknown';
        return "$street, $locality, $country"; // Returning the formatted address
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Failed to get address: ${e.toString()}"; // Returning error message
    }
  }
   Future<List<String>> fetchSuggestions(String input, String apiKey) async {
    final String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'OK') {
          return (result['predictions'] as List).map<String>((p) => p['description'] as String).toList();
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

  void onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      var results = await fetchSuggestions(query, 'YOUR_API_KEY');
      suggestions = results;
      showSuggestions = true;
    } else {
      suggestions = [];
      showSuggestions = false;
    }
    notifyListeners();
  }
  void selectSuggestion(String suggestion) {
  searchController.text = suggestion;  // Assuming you manage TextEditingController inside provider
  showSuggestions = false;
  searchAndNavigate(suggestion);
  notifyListeners();  // This ensures all listeners are notified of the state change
}
 void searchAndNavigate(String query) {
  if (query.isNotEmpty) {
    locationFromAddress(query).then((result) {
      if (result.isNotEmpty) {
        updateCameraPosition(result.first.latitude, result.first.longitude);
        markers.clear();
        markers.add(
          Marker(
            markerId: MarkerId('searchedLocation'),
            position: LatLng(result.first.latitude, result.first.longitude),
            infoWindow: InfoWindow(title: query),
          ),
        );
        getAddressFromLatLng(result.first.latitude, result.first.longitude);
        notifyListeners(); // Notify listeners after updating the state
      }
    }).catchError((e) {
      print("Search Error: $e");
    });
  }
}


  void handleTap(LatLng tappedPoint) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(tappedPoint.latitude, tappedPoint.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}, ${place.country}';
        
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(title: address),
        ));
        _currentAddress = address;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to get address: $e");
    }
  }
}

class FeatureProvider extends  ChangeNotifier {
    Featured? featuredData;
 
   Future<void> fetchFeaturedData() async {
    try {
      featuredData = await FeatureDataProvider()._featureData;
      notifyListeners();
    } catch (e) {
      print("Failed to fetch data: $e");
    }
  }
}

