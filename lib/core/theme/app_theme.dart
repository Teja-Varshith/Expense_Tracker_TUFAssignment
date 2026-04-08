import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightBorder,
    textTheme: _textTheme(Brightness.light),
    colorScheme: const ColorScheme.light(
      primary: AppColors.purple,
      secondary: AppColors.pink,
      surface: AppColors.lightSurface,
      onPrimary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.expense,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: GoogleFonts.dmSans(
        color: AppColors.lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightNavBar,
      selectedItemColor: AppColors.purple,
      unselectedItemColor: AppColors.lightTextMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCardAlt,
      hintStyle: GoogleFonts.dmSans(
        color: AppColors.lightTextMuted,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.expense, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightFab,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkBorder,
    textTheme: _textTheme(Brightness.dark),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.purple,
      secondary: AppColors.pink,
      surface: AppColors.darkSurface,
      onPrimary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.expense,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: GoogleFonts.dmSans(
        color: AppColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkNavBar,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.darkTextMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      hintStyle: GoogleFonts.dmSans(
        color: AppColors.darkTextMuted,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.expense, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkBg,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkFab,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: CircleBorder(),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static TextTheme _textTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final primary =
        isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary;
    final secondary =
        isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary;

    return GoogleFonts.dmSansTextTheme().copyWith(
      displayLarge: GoogleFonts.dmSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      displayMedium: GoogleFonts.dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineLarge: GoogleFonts.dmSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineMedium: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    );
  }
}
