import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GobalStyles {
  static TextStyle headline1 = GoogleFonts.kanit(
      textStyle: const TextStyle(
    fontSize: 72.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ));

  static TextStyle headline2 = GoogleFonts.kanit(
      textStyle: const TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ));
  static TextStyle headline3 = GoogleFonts.kanit(
      textStyle: const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ));
  static TextStyle headline4 = GoogleFonts.kanit(
      textStyle: const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ));

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 14.0,
    fontFamily: 'Hind',
  );

  static const Color primaryColor = Color(0xFF00569D);
  static const Color secondaryColor = Color.fromARGB(255, 159, 210, 252);
  static const Color accentColor = Colors.orange;
  static double screenHeight = 0;
  static double screenWidth = 0;
}
