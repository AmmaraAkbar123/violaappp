import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viola/auth/view_model.dart';
import 'package:viola/providers/adress_provider.dart';
import 'package:viola/providers/myprovider.dart';

import 'package:viola/pages/splashscreen.dart';
import 'package:viola/providers/data_api_provider.dart';
import 'package:viola/providers/user_provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
 @override
Widget build(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=> MyDataApiProvider(),),
      ChangeNotifierProvider(create: (_)=> FeatureDataProvider(),),
      ChangeNotifierProvider(create: (_)=> CategoryProvider(),),
       ChangeNotifierProvider(create: (_)=> AddressProvider(),),
      ChangeNotifierProvider(create: (_)=> MapProvider(),),
     
      ChangeNotifierProvider(create: (_)=> FeatureDataProvider(),),
       ChangeNotifierProvider(create: (_)=> SignInViewModel(),),
       ChangeNotifierProvider(create: (_)=> UserProvider(),),
      
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}
}