import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:viola/auth/api_constant.dart';
import 'package:viola/json_models/category_model.dart';

class CategoryApiService {
  Future<List<Category>> fetchCategories() async {
    Uri uri = Uri.parse(
        '${ApiConstants.categoriesUrl}?parent=true&orderBy=order&sortBy=asc');

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
