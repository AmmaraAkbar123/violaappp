import 'package:flutter/material.dart';
import 'package:viola/json_models/mydata_model.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<Datum> results;

  const SearchResultsScreen({Key? key, required this.results})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index].name.en),
            subtitle: Text(results[index].description.en),
            onTap: () {
              // Maybe push to a detailed screen?
            },
          );
        },
      ),
    );
  }
}
