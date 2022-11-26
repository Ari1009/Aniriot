// ignore_for_file: deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

/// Main app theme, called [AniriotTheme], is defined here.
class AniriotTheme {
  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.questrial(
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.questrial(
      fontSize: 15.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    subtitle1: GoogleFonts.questrial(
      fontSize: 15.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    subtitle2: GoogleFonts.questrial(
      fontSize: 17.0,
      color: Colors.white,
    ),
    headline1: GoogleFonts.questrial(
      fontSize: 31.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.questrial(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.questrial(
      fontSize: 19.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      decoration: TextDecoration.none,
    ),
    headline4: GoogleFonts.questrial(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      decoration: TextDecoration.none,
    ),
    headline5: GoogleFonts.questrial(
      fontSize: 19.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      decoration: TextDecoration.none,
    ),
    headline6: GoogleFonts.questrial(
      fontSize: 19.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Color(0xFF060B16),
      primaryColor: Color(0xFF0D1321),
      accentColor: Color(0xFF133F6E),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF0D1321),
        centerTitle: true,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white60,
        backgroundColor: Color(0xFF0D1321),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.black),
        fillColor: MaterialStateProperty.all( Color.fromARGB(255, 233, 5, 39)),
      ),
      textTheme: darkTextTheme,
    );
  }
}
