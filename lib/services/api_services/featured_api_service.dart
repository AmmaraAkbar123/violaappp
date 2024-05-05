import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:viola/json_models/feature_model.dart'; // Adjust this import based on the actual path

class FeaturedApiService {
  final String baseUrl =
      "http://dev.viola.myignite.online/api/salon_feature?api_token=YOUR_API_TOKEN&myLat=31.4734661&myLon=74.2665947";

  Future<Featured> getFeaturedData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        // Assuming the response is a JSON object
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
