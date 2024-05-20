import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/pages/salon_detail_page.dart';
import 'package:viola/providers/open_store_provider.dart';
import 'package:viola/widgets/main_containers.dart';

class OpenStoresScreen extends StatefulWidget {
  @override
  _OpenStoresScreenState createState() => _OpenStoresScreenState();
}

class _OpenStoresScreenState extends State<OpenStoresScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<OpenStoreProvider>(context, listen: false);
      // Fetch stores if not already loaded or if an error occurred previously
      if (provider.openStores.isEmpty && provider.error == null) {
        provider.fetchAllOpenStores();
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !Provider.of<OpenStoreProvider>(context, listen: false).isLoading &&
        Provider.of<OpenStoreProvider>(context, listen: false).hasMore) {
      Provider.of<OpenStoreProvider>(context, listen: false)
          .fetchAllOpenStores();
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
            body: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.openStores.isEmpty
                    ? Center(
                        child:
                            Text(provider.error ?? "No open stores available."))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.openStores.length,
                        itemBuilder: (context, index) {
                          final salon = provider.openStores[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SalonDetailPage(
                                            salonId: salon.id,
                                          )));
                            },
                            child: MainContainers(
                                data: provider.openStores[index]),
                          );
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
