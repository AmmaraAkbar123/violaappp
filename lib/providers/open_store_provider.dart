import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/services/api_services/api_mydata_service.dart';

class OpenStoreProvider extends ChangeNotifier {
  List<Datum> openStores = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;
  String? error;

  final DataApiService _dataApiService = DataApiService();

  Future<void> fetchAllOpenStores() async {
    isLoading = true;
    error = null; // Reset any previous errors
    currentPage = 1;
    openStores.clear();
    notifyListeners();

    do {
      log('Fetching page: $currentPage');
      await _fetchOpenStores();
      log('Fetched page: $currentPage, hasMore: $hasMore, openStores count: ${openStores.length}');
      notifyListeners(); // Ensure listeners are notified after each fetch
    } while (hasMore && error == null);

    isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchOpenStores() async {
    try {
      Mydata newPageData = await _dataApiService.fetchData(
          page: currentPage, longitude: '74.2665947', latitude: '31.4734661');
      List<Datum> fetchedStores =
          newPageData.data.data.where((store) => !store.closed).toList();
      openStores.addAll(fetchedStores);

      currentPage = newPageData.data.currentPage;
      hasMore = currentPage < newPageData.data.lastPage;
      if (hasMore) currentPage++;
    } catch (e) {
      error = e.toString();
      log('Error fetching open stores: $error');
      hasMore = false;
    }
  }
}
