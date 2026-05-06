import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF4CAF50);
  static const Color darkGrey = Color(0xFF121212);
  static const Color mediumGrey = Color(0xFF1E1E1E);
  static const Color lightGrey = Color(0xFF2C2C2C);
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
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.black,
    elevation: 0,
    centerTitle: false, // Logo a la izquierda
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
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.mediumGrey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.green, width: 1),
    ),
    prefixIconColor: AppColors.green,
    labelStyle: const TextStyle(color: Colors.grey),
  ),
);
