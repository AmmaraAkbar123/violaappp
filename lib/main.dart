import 'package:flutter/material.dart';
import 'package:violaapp/pages/login_page.dart';
import 'package:violaapp/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: const LoginPage_Screen(),
    );
  }
}

