import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  primaryColor: const Color(0xFF4B005F),
  hintColor: const Color.fromARGB(190, 249, 249, 249),
  brightness: Brightness.light,
  dividerColor: const Color(0xFFFFE69B),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4B005F),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 10),
      iconTheme:
          IconThemeData(color: Color.fromRGBO(255, 255, 255, 1), size: 16)),
  iconButtonTheme: const IconButtonThemeData(
      style:
          ButtonStyle(iconColor: MaterialStatePropertyAll(Color(0xFFF9FCF5)))),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 28, color: Colors.black, fontWeight: FontWeight.w900),
    headline2: TextStyle(
        fontSize: 24, color: Colors.black, fontWeight: FontWeight.w900),
    headline3: TextStyle(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.w900),
    headline4: TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
    headline5: TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
    headline6: TextStyle(
      fontSize: 14,
      color: Color(0xFF4B005F),
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    button: TextStyle(
      fontSize: 20,
      color: Color(0xFF4B005F),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFF9F9F9),
  ),
);


// Dark theme data
// final ThemeData darkTheme = ThemeData(
//   primarySwatch: Colors.grey,
//   hintColor: Colors.grey,
//   brightness: Brightness.dark,
 
// );