import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/providers/open_store_provider.dart';
import 'package:viola/widgets/main_containers.dart';

class OpenStoresScreen extends StatefulWidget {
  final List<Datum> openStores;

  const OpenStoresScreen({super.key, required this.openStores});
  @override
  _OpenStoresScreenState createState() => _OpenStoresScreenState();
}

class _OpenStoresScreenState extends State<OpenStoresScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial page of open stores
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final provider = context.read<OpenStoreProvider>();
      if (provider.openStores.isEmpty) {
        provider.fetchOpenStores();
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<OpenStoreProvider>();
    // Check if reached the end of the list and there are more stores to load
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !provider.isLoading &&
        provider.hasMore) {
      provider.fetchOpenStores(loadMore: true); // Fetch more stores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OpenStoreProvider>(
      builder: (context, provider, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text('المتاجر المفتوحة'),
              centerTitle: true,
            ),
            body: provider.isLoading && provider.openStores.isEmpty
                ? Center(child: CircularProgressIndicator())
                : provider.openStores.isEmpty
                    ? Center(child: Text("No open stores available."))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.openStores.length,
                        itemBuilder: (context, index) {
                          return MainContainers(
                              data: provider.openStores[index]);
                        },
                      ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
