import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchProvider extends ChangeNotifier {
  Future<List<String>> searchSalon(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'http://dev.viola.myignite.online/api/search-salon?search=$query'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Check if jsonData is not null and is a List
        if (jsonData != null && jsonData is List) {
          List<String> searchResults = [];
          for (var item in jsonData) {
            // Check if item is a Map and contains the key 'name'
            if (item is Map<String, dynamic> && item.containsKey('name')) {
              searchResults.add(item['name']);
            }
          }
          return searchResults;
        } else {
          // Return an empty list if jsonData is null or not a List
          return [];
        }
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error searching salons: $e');
      throw e;
    }
  }
}
