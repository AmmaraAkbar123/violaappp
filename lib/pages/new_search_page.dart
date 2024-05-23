import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/pages/salon_detail_page.dart';
import 'package:viola/providers/search_provider.dart';
import 'package:viola/widgets/main_containers.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'بحث',
              style: TextStyle(
                color: Colors.purple,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.purple,
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: const TextStyle(
                  color: Color.fromRGBO(75, 0, 95, 1),
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 206, 201, 201), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 206, 201, 201), width: 1.0),
                  ),
                  hintText: 'ابحث عن صالون أو خدمة',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: const Icon(Icons.search,
                      color: Color.fromRGBO(75, 0, 95, 1)),
                ),
                onSubmitted: (query) {
                  Provider.of<SearchProvider>(context, listen: false)
                      .performSearch(query);
                },
                onChanged: (query) {
                  query = query.trim();
                  if (query.isEmpty) {
                    Provider.of<SearchProvider>(context, listen: false)
                        .clearSearch();
                  }
                },
              ),
            ),
            Expanded(child:
                Consumer<SearchProvider>(builder: (context, searchProvider, _) {
              return searchProvider.searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/images/search.png',
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text(
                            'لم يتم العثور على صالون أو خدمة',
                            style: TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.bold,
                                color: Colors.purple),
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
                                  salonId:
                                      searchProvider.searchResults[index].id),
                            ),
                          );
                        },
                        child: MainContainers(
                            data: searchProvider.searchResults[index]),
                      ),
                    );
            }))
          ])),
    );
  }
}
