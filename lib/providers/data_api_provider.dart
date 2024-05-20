import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:viola/json_models/mydata_model.dart';
import 'package:viola/services/api_services/api_mydata_service.dart';

class MyDataApiProvider extends ChangeNotifier {
  Mydata? mydata;
  int currentPage = 1;
  bool hasMore = true;
  bool isPaginating = false;
  String? error;
  Datum? salonDetails;
  final DataApiService _dataApiService = DataApiService();

  // Default longitude and latitude values
  String longitude = '74.2665947'; // Default or dynamic value
  String latitude = '31.4734661'; // Default or dynamic value
  Future<void> fetchData({bool fetchNextPage = false}) async {
    if (fetchNextPage) {
      if (!hasMore) {
        log('No more data to fetch.');
        return;
      }
      if (isPaginating) {
        log('Currently paginating, request to fetch next page ignored.');
        return;
      }
      currentPage++; // Increment page number to fetch next page
      isPaginating = true; // Set paginating flag
    } else {
      currentPage = 1; // Reset to first page for a fresh fetch
    }

    notifyListeners(); // Notify listeners before fetching data

    try {
      // Now includes longitude and latitude
      Mydata newPageData = await _dataApiService.fetchData(
          page: currentPage, longitude: longitude, latitude: latitude);
      if (fetchNextPage && mydata != null) {
        // Append new data if paginating and homepageData is not null
        mydata!.data.data.addAll(newPageData.data.data);
      } else {
        // Set new data if not paginating or if homepageData was initially null
        mydata = newPageData;
      }
      // Update 'hasMore' to determine if more data can be fetched
      hasMore = newPageData.data.currentPage < newPageData.data.lastPage;
      notifyListeners(); // Notify listeners after successful data fetch
    } catch (e) {
      error = e.toString();
      log('Error while fetching data: $error');
      notifyListeners(); // Ensure UI updates to show the error state
    } finally {
      isPaginating = false; // Always reset the paginating flag
    }
  }

  Future<void> fetchSalonDetails(int salonId) async {
    error = null;
    salonDetails = null;
    notifyListeners();

    try {
      Datum? details = await _dataApiService.fetchSalonDetails(salonId);
      // Use direct assignment as null check is unnecessary with nullable types
      salonDetails = details;
      notifyListeners(); // Notify listeners after successfully fetching data
    } catch (e) {
      error = e.toString();
      log("Error fetching salon details: $error"); // Log the error
      notifyListeners(); // Notify listeners in case of error to show error message
    }
  }

  //for dynamic latlngs
  void updateLocation(String newLongitude, String newLatitude) {
    if (longitude != newLongitude || latitude != newLatitude) {
      longitude = newLongitude;
      latitude = newLatitude;
      fetchData(); // Fetch data with the new coordinates
    }
  }
}
