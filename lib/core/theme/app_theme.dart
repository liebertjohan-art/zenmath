import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'zen_colors.dart';
import 'zen_typography.dart';
import 'zen_design_tokens.dart';

class AppTheme {
  static final _darkTokens = ZenDesignTokens(
    background: ZenColors.backgroundDark,
    surface: ZenColors.surfaceDark,
    surfaceVariant: ZenColors.surfaceVariantDark,
    surfaceBright: ZenColors.surfaceBrightDark,
    primary: ZenColors.primaryDark,
    primaryMuted: ZenColors.primaryMutedDark,
    primarySubtle: ZenColors.primaryDark.withOpacity(0.12),
    success: ZenColors.successDark,
    successMuted: ZenColors.successMutedDark,
    error: ZenColors.errorDark,
    errorMuted: ZenColors.errorDark.withOpacity(0.15),
    textPrimary: ZenColors.textPrimaryDark,
    textSecondary: ZenColors.textSecondaryDark,
    textTertiary: ZenColors.textTertiaryDark,
    divider: Colors.white.withOpacity(0.06),
    navBarSurface: ZenColors.navBarSurfaceDark,
  );

  static final _lightTokens = ZenDesignTokens(
    background: ZenColors.backgroundLight,
    surface: ZenColors.surfaceLight,
    surfaceVariant: ZenColors.surfaceVariantLight,
    surfaceBright: ZenColors.surfaceBrightLight,
    primary: ZenColors.primaryLight,
    primaryMuted: ZenColors.primaryMutedLight,
    primarySubtle: ZenColors.primaryLight.withOpacity(0.12),
    success: ZenColors.successLight,
    successMuted: ZenColors.successLight,
    error: ZenColors.errorLight,
    errorMuted: ZenColors.errorLight.withOpacity(0.15),
    textPrimary: ZenColors.textPrimaryLight,
    textSecondary: ZenColors.textSecondaryLight,
    textTertiary: ZenColors.textTertiaryLight,
    divider: Colors.black.withOpacity(0.06),
    navBarSurface: ZenColors.navBarSurfaceLight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkTokens.background,
      primaryColor: _darkTokens.primary,
      colorScheme: ColorScheme.dark(
        primary: _darkTokens.primary,
        secondary: _darkTokens.success,
        surface: _darkTokens.surface,
        error: _darkTokens.error,
        onPrimary: _darkTokens.background,
        onSurface: _darkTokens.textPrimary,
      ),
      textTheme: ZenTypography.getTextTheme(
        _darkTokens.textPrimary,
        _darkTokens.textSecondary,
        _darkTokens.textTertiary,
      ),
      extensions: [_darkTokens],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightTokens.background,
      primaryColor: _lightTokens.primary,
      colorScheme: ColorScheme.light(
        primary: _lightTokens.primary,
        secondary: _lightTokens.success,
        surface: _lightTokens.surface,
        error: _lightTokens.error,
        onPrimary: _lightTokens.background,
        onSurface: _lightTokens.textPrimary,
      ),
      textTheme: ZenTypography.getTextTheme(
        _lightTokens.textPrimary,
        _lightTokens.textSecondary,
        _lightTokens.textTertiary,
      ),
      extensions: [_lightTokens],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1A1A24)),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
