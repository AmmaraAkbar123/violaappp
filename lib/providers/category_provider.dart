import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:viola/json_models/category_model.dart';

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
    notifyListeners(); // Notify listeners to update the UI after data is fetched and state is updated
  }

  Future<List<Category>> fetchCategories() async {
    Uri uri = Uri.parse('$_baseUrl?parent=true&orderBy=order&sortBy=asc');

    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        if (responseJson['success']) {
          List<dynamic> categoryJsonList = responseJson['data'];
          return categoryJsonList
              .map((json) => Category.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to find categories in the response');
        }
      } else {
        throw Exception(
            'Failed to load categories: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }
}




// import 'package:flutter/foundation.dart';
// import 'package:viola/json_models/category_model.dart';

// class CategoryProvider extends ChangeNotifier {
//   List<voila.Category> categories = [];
//   List<bool> _selectedCategories =
//       []; // Define the list to store selection state

//   List<bool> get selectedCategories =>
//       _selectedCategories; // Getter for selectedCategories

//   final CategoryApiService _categoryApiService = CategoryApiService();

//   Future<void> fetchCategories() async {
//     try {
//       categories = await _categoryApiService.fetchCategories();
//       // Initialize or update selected categories list to match the fetched categories
//       _selectedCategories = List<bool>.filled(categories.length, false);
//       notifyListeners();
//     } catch (e) {
//       // Handle exceptions by showing a message or logging errors
//       print('Error fetching categories: $e');
//     }
//   }

//   void toggleCategorySelection(int index, bool? isSelected) {
//     if (isSelected != null && index < _selectedCategories.length) {
//       _selectedCategories[index] = isSelected;
//       notifyListeners();
//     }
//   }
// }
