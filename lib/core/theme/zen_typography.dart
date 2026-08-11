import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZenTypography {
  static TextTheme getTextTheme(Color primary, Color secondary, Color tertiary) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: primary,
        letterSpacing: -0.03 * 72,
        height: 1.0,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.015 * 36,
        height: 1.1,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: -0.01 * 24,
        height: 1.2,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: 0,
        height: 1.3,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primary,
        letterSpacing: 0,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: secondary,
        letterSpacing: 0.005 * 14,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: 0.02 * 14,
        height: 1.2,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondary,
        letterSpacing: 0.04 * 11,
        height: 1.3,
      ),
    );
  }
}
