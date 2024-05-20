class ApiConstants {
  static const String baseUrl = 'https://dev.viola.myignite.online/api/';
  static const String salons = '${baseUrl}salons';
  static const String verifyPhoneNumberUrl = '${baseUrl}verify-phone-no';
  static const String verifyOtpUrl = '${baseUrl}verify-otp';
  static const String registerUrl = '${baseUrl}register';
  static const String categoriesUrl = '${baseUrl}categories';
  static const String featuredUrl = '${baseUrl}salon_feature';
  static const String searchSalonUrl = '${baseUrl}search-salon';
  static const String filterSalonsByCategoriesUrl =
      '${baseUrl}filter-salons-categories';
  static const String salonFavoritesUrl = '${baseUrl}salon_favorites';
  static const String salonFavoritesWithUserIdUrl =
      '$salonFavoritesUrl?user_id=';
  // Google Places API URLs
  static const String googlePlacesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';
  static const String googlePlaceDetailsUrl =
      '$googlePlacesBaseUrl/details/json';
  static const String googlePlaceAutocompleteUrl =
      '$googlePlacesBaseUrl/autocomplete/json';
}
