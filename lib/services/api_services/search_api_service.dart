import 'dart:convert';
import 'package:viola/json_models/mydata_model.dart';
import 'package:http/http.dart' as http;

Future<List<Datum>> searchSalonByName(String name) async {
  final response = await http.get(Uri.parse(
      'http://dev.viola.myignite.online/api/search-salon?name=$name&myLat=31.4734166&myLon=74.2666372'));

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);

    // Assuming 'Homepage' correctly handles the nested 'data'
    Mydata homepage = Mydata.fromJson(jsonData);
    return homepage.data.data; // This should now refer to the list of Datum
  } else {
    throw Exception('Failed to load data');
  }
}
