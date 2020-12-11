import 'package:flutter/material.dart';
import 'my_color.dart';

ThemeData myDarkTheme = ThemeData(
  primarySwatch: MyColor.blue,
  scaffoldBackgroundColor: Color.fromRGBO(47, 49, 53, 1.000),
  brightness: Brightness.dark,
  cardTheme: CardTheme(
    color: Color.fromRGBO(53, 56, 60, 1.000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    hintStyle: TextStyle(
      color: Color.fromRGBO(197, 198, 199, 1.000),
      fontSize: 16,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(125, 126, 131, 1.000),
      ),
      borderRadius: BorderRadius.circular(6.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 255, 255, 1.000),
      ),
      borderRadius: BorderRadius.circular(6.0),
    ),
  ),
);
