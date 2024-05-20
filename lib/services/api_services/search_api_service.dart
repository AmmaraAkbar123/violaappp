import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:viola/auth/api_constant.dart';
import 'package:viola/json_models/mydata_model.dart';

class SearchProvider extends ChangeNotifier {
  List<Datum> _searchResults = [];

  List<Datum> get searchResults => _searchResults;

  Future<void> performSearch(String query) async {
    query = query.trim();
    if (query.isEmpty || query.length < 3) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          '${ApiConstants.searchSalonUrl}?search=$query&myLat=31.4734166&myLon=74.2666372'));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        _searchResults =
            List<Datum>.from(jsonData['data'].map((x) => Datum.fromJson(x)));
        notifyListeners();
      } else {
        _searchResults.clear(); // Clear the results on error
        notifyListeners();
        throw Exception('Failed to load data');
      }
    } catch (e) {
      _searchResults.clear(); // Clear the results on exception
      notifyListeners();
      print('Error searching salons: $e');
    }
  }
}
