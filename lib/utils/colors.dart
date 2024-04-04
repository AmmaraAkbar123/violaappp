import 'package:flutter/material.dart';


final Theme = ThemeData(

  primaryColor: Color(0xFF4B005F),
  hintColor: Color(0xFFF9F9F9),
  brightness: Brightness.light,
  dividerColor: Color(0xFFFFE69B),
  drawerTheme: DrawerThemeData(
    backgroundColor: Color(0xFFEFE0F3)
  ),

  appBarTheme: AppBarTheme(
    color: Color(0xFF4B005F),
  ),

  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll(Color(0xFFF9FCF5))
    )
  ),

  textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.w900),
      headline2: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w900),
      headline3: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w900),
      headline4: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
      headline5: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
      headline6: TextStyle(fontSize: 14, color: Color(0xFF4B005F),),
      subtitle1: TextStyle(fontSize: 16, color: Colors.black,),
      subtitle2: TextStyle(fontSize: 16, color: Colors.black,),
      bodyText1: TextStyle(fontSize: 16, color: Colors.black,),
      bodyText2: TextStyle(fontSize: 14, color: Colors.black,),
      button: TextStyle(fontSize: 20, color: Color(0xFF4B005F),
      
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFF9F9F9),
    ),
);


// Dark theme data
// final ThemeData darkTheme = ThemeData(
//   primarySwatch: Colors.grey,
//   hintColor: Colors.grey,
//   brightness: Brightness.dark,
 
// );