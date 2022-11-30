import 'package:flutter/material.dart';

class AppTheme {
  static const Color yellow = Color.fromRGBO(253, 210, 40, 1),
      yellowDark = Color.fromRGBO(255, 187, 1, 1),
      yellowLow = Color.fromRGBO(254, 248, 187, 1),
      black = Color.fromRGBO(33, 26, 29, 1),
      white = Colors.white,
      whiteLow = Color.fromRGBO(255, 255, 255, .5);

  static final ThemeData theme = ThemeData.light().copyWith(
    primaryColor: yellow,

    // Scaffold
    scaffoldBackgroundColor: white,
  );
}
