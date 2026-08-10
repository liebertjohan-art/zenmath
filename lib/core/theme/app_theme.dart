import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'zen_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: ZenColors.textPrimary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: ZenColors.textPrimary,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: ZenColors.textPrimary,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ZenColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: ZenColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: ZenColors.textPrimary,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ZenColors.zenGold,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ZenColors.textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ZenColors.midnightBlack,
      primaryColor: ZenColors.zenGold,
      colorScheme: const ColorScheme.dark(
        primary: ZenColors.zenGold,
        secondary: ZenColors.sageGreen,
        surface: ZenColors.deepSlate,
        error: ZenColors.softCoral,
        onPrimary: ZenColors.midnightBlack,
        onSurface: ZenColors.textPrimary,
      ),
      textTheme: textTheme,
      cardTheme: CardTheme(
        color: ZenColors.deepSlate,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
