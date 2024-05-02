import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:viola/json_models/mydata_model.dart';

class DataApiService {
  Uri _baseUri = Uri.parse('http://dev.viola.myignite.online/api/salons');


  // Modified fetchData to accept a page number.
  Future<Mydata> fetchData({int page = 1}) async {
    var parameters = {
      'per_page': '10', // You can adjust the per_page to any number you prefer
      'page': page.toString(), // The page number to fetch
      'myLon': '74.2665947', // Longitude (can be dynamic if needed)
      'myLat': '31.4734661', // Latitude (can be dynamic if needed)
      'closed': '', // Example parameter, can be modified according to need
      'promotions': '' // Example parameter, can be modified according to need
    };
    // Setting the query parameters dynamically based on the method input
    var url = _baseUri.replace(queryParameters: parameters);
    return _performGetRequest<Mydata>(url);
  }

  Future<Datum> fetchSalonDetails(int salonId) async {
    var url = Uri.parse('${_baseUri.toString()}/$salonId');
    return _performGetRequest<Datum>(url);
  }

  Future<T> _performGetRequest<T>(Uri url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        // Using a generic method to deserialize JSON based on the type parameter T
        return T == Mydata ? Mydata.fromJson(jsonData) as T : Datum.fromJson(jsonData['data']) as T;
      } else {
        throw Exception('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow; // Or handle it more gracefully depending on your application needs
    }
  }
}