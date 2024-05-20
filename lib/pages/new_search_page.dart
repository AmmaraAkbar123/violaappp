import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/pages/salon_detail_page.dart';
import 'package:viola/services/api_services/search_api_service.dart';
import 'package:viola/widgets/main_containers.dart';

class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Search now",
            style: TextStyle(
              color: Colors.purple,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.purple),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'ابحث عن موقع',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: const Icon(Icons.search, size: 20),
                ),
                onChanged: (query) {
                  query = query.trim();
                  if (query.isEmpty) {
                    _searchController
                        .clear(); // Optionally clear the text field
                  }
                  Provider.of<SearchProvider>(context, listen: false)
                      .performSearch(query);
                },
              ),
            ),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, _) {
                  return searchProvider.searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 120,
                              ),
                              Image.asset(
                                "assets/images/search.png",
                                height: 120,
                              ),
                              const Text(
                                'No results found',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchProvider.searchResults.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalonDetailPage(
                                      salonId: searchProvider
                                          .searchResults[index].id),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: MainContainers(
                                  data: searchProvider.searchResults[index]),
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
