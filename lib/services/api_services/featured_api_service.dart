import 'package:http/http.dart' as http;
import 'package:viola/auth/api_constant.dart';
import 'dart:convert';
import 'package:viola/json_models/feature_model.dart'; // Adjust this import based on the actual path

class FeaturedApiService {
  // No longer necessary to include the base URL here
  final String apiToken; // Best practice to inject dependencies like API tokens
  final double myLat = 31.4734661;
  final double myLon = 74.2665947;

  FeaturedApiService({required this.apiToken});

  Future<Featured> getFeaturedData() async {
    String url =
        '${ApiConstants.featuredUrl}?api_token=$apiToken&myLat=$myLat&myLon=$myLon';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Featured.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load featured data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
