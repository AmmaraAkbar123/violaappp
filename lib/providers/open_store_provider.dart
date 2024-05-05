import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/services/api_services/api_mydata_service.dart';

class OpenStoreProvider extends ChangeNotifier {
  List<Datum> openStores = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isPaginating = false;
  bool isLoading = false;
  String? error;

  final DataApiService _dataApiService = DataApiService();

  Future<void> fetchOpenStores({bool loadMore = false}) async {
    // Check if there are more pages to load
    if (!loadMore && !hasMore) {
      return;
    }

    // Prevent simultaneous paginations
    if (loadMore && isPaginating) {
      return;
    }

    isLoading = true;
    if (!loadMore) {
      // Reset pagination state for a new fetch
      currentPage = 1;
      openStores.clear();
      error = null;
    }
    isPaginating = true;
    notifyListeners();

    try {
      // Fetch data for the current page
      Mydata newPageData = await _dataApiService.fetchData(page: currentPage);

      // Add fetched stores to the list
      openStores.addAll(newPageData.data.data.where((store) => !store.closed));

      // Update pagination status
      hasMore = newPageData.data.currentPage < newPageData.data.lastPage;
      currentPage++;

      // If there are more pages and it's a loadMore request, fetch the next page
      if (loadMore && hasMore) {
        await fetchOpenStores(loadMore: true);
      }
    } catch (e) {
      error = e.toString();
      log('Error fetching open stores: $error');
    } finally {
      isLoading = false;
      isPaginating = false;
      notifyListeners();
    }
  }
}
