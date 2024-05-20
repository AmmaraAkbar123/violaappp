import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:viola/auth/api_constant.dart';
import 'package:viola/providers/user_provider.dart';
import 'package:viola/services/api_services/authentication_service.dart';
import 'dart:convert';
import 'package:viola/services/shared_preff/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();
  Set<int> _favorites = {};
  AuthenticationService _authService;
  UserProvider _userProvider;

  bool isFavorite(int salonId) {
    return _favorites.contains(salonId);
  }

  FavoritesProvider(this._authService, this._userProvider) {
    loadFavoritesFromApi();
  }

  void updateDependencies(
      AuthenticationService authService, UserProvider userProvider) {
    _authService = authService;
    _userProvider = userProvider;
    loadFavoritesFromApi();
  }

  Set<int> get favorites => _favorites;

  Future<void> loadFavoritesFromApi() async {
    if (_userProvider.user.userId > 0 && _userProvider.user.isLoggedIn) {
      String? token = await _authService.loadToken();

      if (token == null) {
        print('Authentication token not available.');
        return;
      }

      Uri uri = Uri.parse(ApiConstants.salonFavoritesWithUserIdUrl +
          _userProvider.user.userId.toString());
      var response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          List<dynamic> serverFavorites = responseData['data'];
          _favorites = Set.from(
              serverFavorites.map((f) => int.parse(f['salon_id'].toString())));
          notifyListeners();
        } else {
          print('Failed to load favorites: ${responseData['message']}');
        }
      } else {
        print(
            'Failed to fetch favorites from server. Status code: ${response.statusCode}');
      }
    } else {
      print('User ID is invalid or user is not logged in.');
    }
  }

  Future<void> saveFavorites() async {
    await _prefsService.save('favorites', json.encode(_favorites.toList()));
  }

// add and remove favorites
  Future<void> toggleFavorite(BuildContext context, int salonId) async {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    String? token = await authService.loadToken();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    int userId = userProvider.user.userId;

    if (userId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid user ID or not logged in."),
          backgroundColor: Colors.red));
      return;
    }

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Authentication token is not available."),
          backgroundColor: Colors.red));
      return;
    }

    try {
      bool favoriteStatus = isFavorite(salonId);

      if (favoriteStatus) {
        await _removeFavoriteFromApi(token, userId, salonId);
        _favorites.remove(salonId); // Remove from local favorites
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        await _addFavoriteToApi(token, userId, salonId);
        _favorites.add(salonId); // Add to local favorites
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }

      await saveFavorites();
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to update favorites. Please try again."),
          backgroundColor: Colors.red));
      print('Error toggling favorite: $e');
    }
  }

  Future<void> _addFavoriteToApi(
      String apiToken, int userId, int salonId) async {
    var queryParameters = {
      "user_id": userId.toString(),
      "salon_id": salonId.toString(),
    };

    Uri uri = Uri.parse(ApiConstants.salonFavoritesUrl);

    var response = await http.post(uri,
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(queryParameters));

    if (response.statusCode != 200) {
      throw Exception('Failed to add to favorites on server');
    }
  }

  Future<void> _removeFavoriteFromApi(
      String apiToken, int userId, int salonId) async {
    var queryParameters = {
      "user_id": userId.toString(),
      "salon_id": salonId.toString(),
    };
    Uri uri = Uri.parse('${ApiConstants.salonFavoritesUrl}/$salonId');

    var response = await http.delete(uri,
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(queryParameters));

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites on server');
    }
  }
}
