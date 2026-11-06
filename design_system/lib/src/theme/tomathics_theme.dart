import 'package:flutter/material.dart';

import '../tokens/tomathics_colors.dart';
import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';
import '../tokens/tomathics_typography.dart';
import 'tomathics_semantic_colors.dart';

/// Builds the light and dark Material 3 themes from Tomathics tokens.
abstract final class TomathicsTheme {
  static ThemeData light() => _build(TomathicsColors.light, Brightness.light);

  static ThemeData dark() => _build(TomathicsColors.dark, Brightness.dark);

  static TomathicsSemanticColors semantic(BuildContext context) {
    return Theme.of(context).extension<TomathicsSemanticColors>()!;
  }

  static ThemeData _build(TomathicsColorPalette p, Brightness brightness) {
    final semantic = brightness == Brightness.light
        ? TomathicsSemanticColors.light()
        : TomathicsSemanticColors.dark();
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.onPrimaryContainer,
      secondary: p.secondary,
      onSecondary: p.onSecondary,
      tertiary: p.primaryHover,
      onTertiary: p.onPrimary,
      error: semantic.danger,
      onError: semantic.onDanger,
      surface: p.surface,
      onSurface: p.textPrimary,
      surfaceContainerHighest: p.surfaceRaised,
      onSurfaceVariant: p.textSecondary,
      outline: p.borderStrong,
      outlineVariant: p.border,
      shadow: p.scrim,
      scrim: p.scrim,
      inverseSurface: p.inverseSurface,
      onInverseSurface: p.onInverseSurface,
      inversePrimary: brightness == Brightness.light
          ? TomathicsColors.dark.primary
          : TomathicsColors.light.primary,
    );
    final textTheme = TomathicsTypography.textTheme.apply(
      bodyColor: p.textPrimary,
      displayColor: p.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      textTheme: textTheme,
      dividerColor: p.border,
      splashFactory: InkSparkle.splashFactory,
      extensions: [semantic],
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TomathicsTypography.titleLarge.copyWith(
          color: p.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: TomathicsRadius.lgAll,
          side: BorderSide(color: p.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TomathicsSpacing.lg,
          vertical: TomathicsSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: TomathicsRadius.mdAll,
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: TomathicsRadius.mdAll,
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: TomathicsRadius.mdAll,
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: TomathicsRadius.mdAll,
          borderSide: BorderSide(color: semantic.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: TomathicsRadius.mdAll,
          borderSide: BorderSide(color: semantic.danger, width: 1.5),
        ),
        labelStyle: TomathicsTypography.bodyMedium.copyWith(
          color: p.textSecondary,
        ),
        hintStyle: TomathicsTypography.bodyMedium.copyWith(color: p.textMuted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 44),
          padding: const EdgeInsets.symmetric(horizontal: TomathicsSpacing.lg),
          shape: const RoundedRectangleBorder(
            borderRadius: TomathicsRadius.mdAll,
          ),
          textStyle: TomathicsTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: TomathicsRadius.mdAll,
          ),
          side: BorderSide(color: p.borderStrong),
          foregroundColor: p.textPrimary,
          textStyle: TomathicsTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: TomathicsRadius.mdAll,
          ),
          textStyle: TomathicsTypography.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(44, 44),
          foregroundColor: p.textSecondary,
          shape: const RoundedRectangleBorder(
            borderRadius: TomathicsRadius.smAll,
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: p.inverseSurface,
          borderRadius: TomathicsRadius.smAll,
        ),
        textStyle: TomathicsTypography.bodySmall.copyWith(
          color: p.onInverseSurface,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.inverseSurface,
        contentTextStyle: TomathicsTypography.bodyMedium.copyWith(
          color: p.onInverseSurface,
        ),
        actionTextColor: p.primaryHover,
        shape: const RoundedRectangleBorder(
          borderRadius: TomathicsRadius.mdAll,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TomathicsSpacing.lg,
          vertical: TomathicsSpacing.xs,
        ),
        iconColor: p.textSecondary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.onPrimary : p.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.primary : p.border,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: TomathicsRadius.xlAll,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TomathicsRadius.xl),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: p.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          TomathicsTypography.labelSmall.copyWith(
            letterSpacing: 0,
            fontSize: 12,
            color: p.textPrimary,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.border, space: 1, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primary,
        linearTrackColor: p.surfaceSunken,
        circularTrackColor: p.surfaceSunken,
      ),
    );
  }
}
