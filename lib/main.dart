import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/auth/view_model.dart';
import 'package:viola/pages/home_page.dart';
import 'package:viola/providers/adress_provider.dart';
import 'package:viola/pages/splashscreen.dart';
import 'package:viola/providers/category_provider.dart';
import 'package:viola/providers/data_api_provider.dart';
import 'package:viola/providers/favorite_provider.dart';
import 'package:viola/providers/feature_data_provider.dart';
import 'package:viola/providers/map_provider.dart';
import 'package:viola/providers/open_store_provider.dart';
import 'package:viola/providers/user_provider.dart';
import 'package:viola/services/api_services/authentication_service.dart';
import 'package:viola/services/api_services/search_api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProxyProvider2<AuthenticationService, UserProvider,
            FavoritesProvider>(
          create: (context) => FavoritesProvider(
            Provider.of<AuthenticationService>(context, listen: false),
            Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, authService, userProvider, favoritesProvider) {
            favoritesProvider?.updateDependencies(authService, userProvider);
            return favoritesProvider!;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => SignInViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyDataApiProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FeatureDataProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => CategoryProvider(),
        // ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => MapProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FeatureDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (_) => OpenStoreProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
        routes: {"/home": (context) => const HomePage()},
      ),
    );
  }
}
