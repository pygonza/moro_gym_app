import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF4CAF50); // Verde vibrante tipo fitness
  static const Color darkGrey = Color(0xFF121212);
  static const Color mediumGrey = Color(0xFF1E1E1E);
}

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.green,
    primary: AppColors.green,
    onPrimary: AppColors.black,
    secondary: AppColors.white,
    onSecondary: AppColors.black,
    surface: AppColors.darkGrey,
    onSurface: AppColors.white,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.black,
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).apply(
    bodyColor: AppColors.white,
    displayColor: AppColors.white,
  ),
  cardTheme: CardThemeData(
    color: AppColors.mediumGrey,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.black,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 20, 
      fontWeight: FontWeight.bold, 
      color: AppColors.white,
    ),
    iconTheme: const IconThemeData(color: AppColors.green),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.green,
      foregroundColor: AppColors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.green,
      side: const BorderSide(color: AppColors.green),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.mediumGrey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: AppColors.green,
    labelStyle: const TextStyle(color: Colors.grey),
  ),
);
