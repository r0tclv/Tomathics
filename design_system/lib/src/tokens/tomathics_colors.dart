import 'package:flutter/material.dart';

/// Surface, text, border, and brand colors for one brightness.
class TomathicsColorPalette {
  const TomathicsColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryHover,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.scrim,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryHover;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceSunken;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderStrong;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color scrim;
}

/// Official light and dark palettes. Bright blue-violet and cyan define the
/// brand; the grid and graph nodes make the canvas uniquely Tomathics.
abstract final class TomathicsColors {
  static const light = TomathicsColorPalette(
    primary: Color(0xFF4F5FE8),
    onPrimary: Color(0xFFFFFFFF),
    primaryHover: Color(0xFF3D4DD0),
    primaryContainer: Color(0xFFE7E9FF),
    onPrimaryContainer: Color(0xFF1F2A82),
    secondary: Color(0xFF087F8C),
    onSecondary: Color(0xFFFFFFFF),
    background: Color(0xFFF4F6FB),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFAFBFF),
    surfaceSunken: Color(0xFFEDF0F7),
    textPrimary: Color(0xFF192238),
    textSecondary: Color(0xFF59657C),
    textMuted: Color(0xFF7C879B),
    border: Color(0xFFDCE2EE),
    borderStrong: Color(0xFFBBC5D7),
    inverseSurface: Color(0xFF192238),
    onInverseSurface: Color(0xFFF4F6FB),
    scrim: Color(0x66101A32),
  );

  static const dark = TomathicsColorPalette(
    primary: Color(0xFF8790FF),
    onPrimary: Color(0xFF111747),
    primaryHover: Color(0xFFA6ACFF),
    primaryContainer: Color(0xFF282F70),
    onPrimaryContainer: Color(0xFFE2E5FF),
    secondary: Color(0xFF50D2D9),
    onSecondary: Color(0xFF062C31),
    background: Color(0xFF0B1020),
    surface: Color(0xFF121A2B),
    surfaceRaised: Color(0xFF182338),
    surfaceSunken: Color(0xFF0E1525),
    textPrimary: Color(0xFFF1F4FF),
    textSecondary: Color(0xFFB1BCD2),
    textMuted: Color(0xFF8491AA),
    border: Color(0xFF293650),
    borderStrong: Color(0xFF3B4B69),
    inverseSurface: Color(0xFFE8ECF8),
    onInverseSurface: Color(0xFF192238),
    scrim: Color(0x99030710),
  );
}
