import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color white = Colors.white;

  // Paleta extraída del logo Quipubox
  static const Color navy = Color(0xFF0B2340); // azul marino del cubo/logo
  static const Color navyLight = Color(0xFF16406E); // variante más clara para dark mode / hover
  static const Color teal = Color(0xFF17ABA6); // turquesa de las líneas del quipu
  static const Color tealLight = Color(0xFF3FC7C2); // turquesa claro para acentos en dark mode

  static const Color primary = navy;
  static const Color primaryLight = navyLight;
  static const Color accent = teal;
  static const Color accentLight = tealLight;

  static const Color error = Color(0xFFD32F2F);
  static const Color errorDark = Color(0xFFFF6B6B);

  static const Color scaffoldLight = Color(0xFFF4F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color scaffoldDark = Color(0xFF0A1420);
  static const Color surfaceDark = Color(0xFF141F2D);

  static final ThemeData light = _buildLight();
  static final ThemeData dark = _buildDark();

  static ThemeData _buildLight() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: teal,
      onPrimary: white,
      secondary: navy,
      onSecondary: white,
      tertiary: teal,
      onTertiary: white,
      surface: surfaceLight,
      onSurface: const Color(0xFF17212B),
      error: error,
      onError: white,
      outline: const Color(0xFFD5DEE8),
      outlineVariant: const Color(0xFFE3EAF1),
    );

    return _baseTheme(scheme).copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldLight,
      appBarTheme: _appBarTheme(
        background: navy,
        foreground: white,
      ),
      inputDecorationTheme: _inputTheme(
        scheme: scheme,
        fillColor: surfaceLight,
        focusColor: teal,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: teal,
        linearTrackColor: teal.withValues(alpha: 0.16),
        circularTrackColor: scheme.outlineVariant,
        strokeWidth: 4,
      ),
    );
  }

  static ThemeData _buildDark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: tealLight,
      brightness: Brightness.dark,
    ).copyWith(
      primary: tealLight,
      onPrimary: const Color(0xFF06211F),
      secondary: navyLight,
      onSecondary: white,
      tertiary: tealLight,
      onTertiary: const Color(0xFF06211F),
      surface: surfaceDark,
      onSurface: const Color(0xFFE8EEF5),
      error: errorDark,
      onError: const Color(0xFF101418),
      outline: const Color(0xFF3B4653),
      outlineVariant: const Color(0xFF2B3542),
    );

    return _baseTheme(scheme).copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldDark,
      appBarTheme: _appBarTheme(
        background: scaffoldDark,
        foreground: const Color(0xFFE8EEF5),
      ),
      inputDecorationTheme: _inputTheme(
        scheme: scheme,
        fillColor: surfaceDark,
        focusColor: tealLight,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: tealLight,
        linearTrackColor: tealLight.withValues(alpha: 0.18),
        circularTrackColor: scheme.outlineVariant,
        strokeWidth: 4,
      ),
    );
  }

  static ThemeData _baseTheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      primaryColor: scheme.primary,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 1,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: isDark ? 0.70 : 0.90),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          foregroundColor: scheme.primary,
          side: BorderSide(
            color: isDark
                ? scheme.outline.withValues(alpha: 0.85)
                : scheme.outline,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 3,
        focusElevation: 3,
        hoverElevation: 4,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
        selectedColor: scheme.primary.withValues(alpha: 0.16),
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface,
        modalBarrierColor: Colors.black.withValues(alpha: 0.55),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark
            ? const Color(0xFF26313D)
            : const Color(0xFF17212B),
        contentTextStyle: const TextStyle(
          color: white,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 24),
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
      ),
    );
  }

  static AppBarTheme _appBarTheme({
    required Color background,
    required Color foreground,
  }) {
    return AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: foreground),
    );
  }

  static InputDecorationTheme _inputTheme({
    required ColorScheme scheme,
    required Color fillColor,
    required Color focusColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      floatingLabelStyle: TextStyle(
        color: focusColor,
        fontWeight: FontWeight.w800,
      ),
      prefixIconColor: scheme.onSurfaceVariant,
      suffixIconColor: scheme.onSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
    );
  }
}