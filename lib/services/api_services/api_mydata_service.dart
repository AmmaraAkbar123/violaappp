import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:viola/auth/api_constant.dart';
import 'package:viola/json_models/mydata_model.dart';

class DataApiService {
  // Replace direct URI with ApiConstants usage
  final Uri _baseUri = Uri.parse(ApiConstants.salons);

  Future<Mydata> fetchData({
    int page = 1,
    required String longitude,
    required String latitude,
    List<int>? categoryIds,
  }) async {
    var parameters = {
      'per_page': '10',
      'page': page.toString(),
      'myLon': longitude,
      'myLat': latitude,
      'closed': '',
      'promotions': '',
      if (categoryIds != null && categoryIds.isNotEmpty)
        'categories_ids': categoryIds.map((id) => id.toString()).toList(),
    };
    var url = _baseUri.replace(queryParameters: parameters);
    print("URL being hit: $url");
    return await _performGetRequest<Mydata>(url);
  }

  Future<List<Datum>> fetchAllFeaturedStores() async {
    int currentPage = 1;
    List<Datum> allFeaturedStores = [];
    bool hasMorePages = true;

    while (hasMorePages) {
      Mydata pageData = await fetchData(
          page: currentPage, longitude: '74.2665947', latitude: '31.4734661');
      allFeaturedStores
          .addAll(pageData.data.data.where((datum) => datum.featured));

      if (currentPage >= pageData.data.lastPage) {
        hasMorePages = false;
      } else {
        currentPage++;
      }
    }

    return allFeaturedStores;
  }

  Future<Datum> fetchSalonDetails(int salonId) async {
    var url =
        Uri.parse('${ApiConstants.salons}/$salonId'); // Use constants for URL
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("Raw JSON data: ${response.body}");
      try {
        return Datum.fromJson(json['data']);
      } catch (e) {
        print("Error parsing JSON to Datum: $e");
        rethrow;
      }
    } else {
      throw HttpException(
          'Failed to fetch details with status code: ${response.statusCode}');
    }
  }

  Future<T> _performGetRequest<T>(Uri url) async {
    var response = await http.get(url);
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData == null) {
        throw Exception('Invalid JSON data');
      }

      if (T.toString() == 'List<Datum>') {
        List<dynamic> dataList = jsonData['data'];
        return dataList.map((datumJson) => Datum.fromJson(datumJson)).toList()
            as T;
      } else {
        return Mydata.fromJson(jsonData) as T;
      }
    } else {
      throw Exception(
          'Failed to load data with status code: ${response.statusCode}');
    }
  }
}
