import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/services/api_services/api_mydata_service.dart';

class MyDataApiProvider extends ChangeNotifier {
  Mydata? mydata;
  int currentPage = 1;  // Track the current page
  bool isLoading = false;  // Flag to check if data is being loaded
  bool hasMore = true; 
  bool isPaginating = false; // Flag to check if there are more pages available
  String? error;
  Datum? salonDetails;
  final DataApiService _dataApiService = DataApiService();

  // Fetch data with optional pagination
  Future<void> fetchData({bool fetchNextPage = false}) async {
    if (fetchNextPage && !hasMore) {
      return; // If there are no more pages, do not attempt to fetch more
    }

      if (fetchNextPage) {
      if (isPaginating) {
        // Prevent multiple simultaneous pagination requests
        return;
      }
      currentPage++; // Increment page number to fetch next page
      isPaginating = true; // Set paginating flag
    } else {
      currentPage = 1; // Reset to first page for a fresh fetch
    }

    notifyListeners();

    try {
      Mydata newPageData = await _dataApiService.fetchData(page: currentPage);
      if (fetchNextPage && mydata != null) {
        // If fetching next page, append new data
        mydata!.data.data.addAll(newPageData.data.data);
      } else {
        // If not fetching next page, replace existing data
        mydata = newPageData;
      }
        // Update hasMore based on current and last page comparison
      hasMore = newPageData.data.currentPage < newPageData.data.lastPage;
    } catch (e) {
      error = e.toString();
      log('Error while fetching data: $error');
    } finally {
      isPaginating = false; // Reset paginating flag
      notifyListeners(); // Notify listeners to update UI
    }
  }

  // Fetch details of a specific salon
  Future<void> fetchSalonDetails(int salonId) async {
    error = null;
    salonDetails = null;  // Clear previous details
    notifyListeners();

    try {
      salonDetails = await _dataApiService.fetchSalonDetails(salonId);
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
