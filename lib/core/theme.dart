import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF4CAF50);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF212121); // Añadido darkGrey
  static const Color textDark = Color(0xFF212121);
}

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.green,
    primary: AppColors.green,
    onPrimary: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.textDark,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.lightGrey,
  textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
    bodyColor: AppColors.textDark,
    displayColor: AppColors.textDark,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.textDark,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 18, 
      fontWeight: FontWeight.bold, 
      color: AppColors.textDark,
    ),
    iconTheme: const IconThemeData(color: AppColors.green),
  ),
  cardTheme: const CardThemeData( // Corregido a CardThemeData
    color: AppColors.white,
    elevation: 2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.green,
      foregroundColor: AppColors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
