import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:viola/auth/api_constant.dart';
import 'package:viola/json_models/category_model.dart' as viola;
import 'package:viola/json_models/mydata_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<viola.Category> categories = [];
  List<bool> _selectedCategories = []; // List to store selection state
  List<Datum> filteredSalons = []; // List to hold filtered salons
  bool isLoading = false; // Track loading status
  String? error; // To hold any error message

  List<bool> get selectedCategories =>
      _selectedCategories; // Getter for selectedCategories

  // Getter to retrieve selected category IDs
  List<int> get selectedCategoryIds => categories
      .asMap()
      .entries
      .where((entry) => _selectedCategories[entry.key])
      .map((entry) => entry.value.id)
      .toList();

  bool get hasSelectedCategories => selectedCategoryIds.isNotEmpty;
  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(ApiConstants.categoriesUrl));
      final jsonData = json.decode(response.body);

      if (jsonData is List) {
        categories = jsonData
            .map((categoryJson) => viola.Category.fromJson(categoryJson))
            .toList();
      } else if (jsonData is Map<String, dynamic>) {
        // Assuming the category data is stored under a key named 'data'
        final categoryData = jsonData['data'];

        if (categoryData is List) {
          categories = categoryData
              .map((categoryJson) => viola.Category.fromJson(categoryJson))
              .toList();
        } else {
          throw Exception(
              'Invalid category data format: Expected a List, received ${categoryData.runtimeType}.');
        }
      } else {
        throw Exception(
            'Invalid data format: Expected a List or Map, received ${jsonData.runtimeType}.');
      }

      // Initialize selected categories state only if it's empty
      if (_selectedCategories.isEmpty) {
        _selectedCategories = List<bool>.filled(categories.length, false);
      }
    } catch (e) {
      error = 'Error fetching categories: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch salons based on selected category IDs
  Future<void> fetchSalonsByCategory() async {
    if (selectedCategoryIds.isEmpty) {
      throw ("Please select at least one category.");
    }
    try {
      // Use SalonFilterService to fetch filtered salons
      final salonFilterService = SalonFilterService();
      filteredSalons = await salonFilterService.fetchFilteredSalons(
          categoryIds: selectedCategoryIds);
      notifyListeners(); // Notify listeners about the update
    } catch (e) {
      throw ('Error fetching filtered salons: $e');
    }
  }

  void toggleCategorySelection(int index, bool? isSelected) {
    if (isSelected != null && index < _selectedCategories.length) {
      _selectedCategories[index] = isSelected;
      notifyListeners();
    }
  }

  void clearSelectedCategories() {
    _selectedCategories = List<bool>.filled(categories.length, false);
    filteredSalons.clear(); // Clear the list of filtered salons
    notifyListeners();
  }

  // Method to fetch salons based on selected categories
  Future<List<Datum>> fetchFilteredSalons() async {
    if (selectedCategoryIds.isEmpty) {
      throw Exception("No categories selected.");
    }
    try {
      isLoading = true;
      notifyListeners();
      // Use SalonFilterService to fetch filtered salons
      final salonFilterService = SalonFilterService();
      return await salonFilterService.fetchFilteredSalons(
        categoryIds: selectedCategoryIds,
      );
    } catch (e) {
      error = 'Error fetching filtered salons: ${e.toString()}';
      rethrow; // Rethrow to handle in UI
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class SalonFilterService {
  Future<List<Datum>> fetchFilteredSalons({
    required List<int> categoryIds,
  }) async {
    Uri filterUri = Uri.parse(ApiConstants.filterSalonsByCategoriesUrl);
    var body = json.encode({
      'categories_ids': categoryIds.map((id) => id.toString()).toList(),
    });

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(filterUri, headers: headers, body: body);
    print("Filter URL being hit: $filterUri with body $body");

    return _handlePostRequest<List<Datum>>(response);
  }

  List<Datum> _handlePostRequest<T>(http.Response response) {
    print('API Response Body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data with status code: ${response.statusCode}');
    }

    var jsonData = json.decode(response.body);
    if (T == List<Datum>) {
      List<dynamic> dataList = jsonData['data'];
      return dataList.map((datumJson) => Datum.fromJson(datumJson)).toList()
          as List<Datum>;
    } else {
      throw Exception("Unexpected generic type $T");
    }
  }
}
