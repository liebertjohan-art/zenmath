import 'package:flutter/material.dart';

class ZenDesignTokens extends ThemeExtension<ZenDesignTokens> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceBright;
  final Color primary;
  final Color primaryMuted;
  final Color primarySubtle;
  final Color success;
  final Color successMuted;
  final Color error;
  final Color errorMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color divider;
  final Color navBarSurface;

  const ZenDesignTokens({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceBright,
    required this.primary,
    required this.primaryMuted,
    required this.primarySubtle,
    required this.success,
    required this.successMuted,
    required this.error,
    required this.errorMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.divider,
    required this.navBarSurface,
  });

  @override
  ThemeExtension<ZenDesignTokens> copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceBright,
    Color? primary,
    Color? primaryMuted,
    Color? primarySubtle,
    Color? success,
    Color? successMuted,
    Color? error,
    Color? errorMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? divider,
    Color? navBarSurface,
  }) {
    return ZenDesignTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      primary: primary ?? this.primary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      success: success ?? this.success,
      successMuted: successMuted ?? this.successMuted,
      error: error ?? this.error,
      errorMuted: errorMuted ?? this.errorMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      divider: divider ?? this.divider,
      navBarSurface: navBarSurface ?? this.navBarSurface,
    );
  }

  @override
  ThemeExtension<ZenDesignTokens> lerp(
      covariant ThemeExtension<ZenDesignTokens>? other, double t) {
    if (other is! ZenDesignTokens) return this;
    return ZenDesignTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      success: Color.lerp(success, other.success, t)!,
      successMuted: Color.lerp(successMuted, other.successMuted, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorMuted: Color.lerp(errorMuted, other.errorMuted, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      navBarSurface: Color.lerp(navBarSurface, other.navBarSurface, t)!,
    );
  }
}
