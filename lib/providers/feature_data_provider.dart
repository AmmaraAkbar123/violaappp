import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:viola/json_models/feature_model.dart';

class FeatureDataProvider extends ChangeNotifier {
  late Future<Featured> _featureData;
  Future<Featured> get featureData => _featureData;

  FeatureDataProvider() {
    _featureData = getDataApi();
  }

  Future<Featured> getDataApi() async {
    try {
      final response = await http.get(Uri.parse(
          "http://dev.viola.myignite.online/api/salon_feature?api_token&myLat=31.4734661&myLon=74.2665947"));

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
