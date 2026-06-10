import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static final Color primary = Colors.lightBlue[800]!;
  static final Color primaryLight = Colors.lightBlue[600]!;

  static const Color white = Colors.white;
  static const Color error = Colors.red;
  static const Color errorDark = Colors.redAccent;

  static final Color scaffoldLight = Colors.grey.shade200;
  static final Color backgroundLight = Colors.grey.shade300;
  static const Color cardLight = Colors.white;

  static final Color scaffoldDark = Colors.grey.shade800;
  static final Color backgroundDark = Colors.grey.shade900;
  static final Color cardDark = Colors.grey.shade800;

  static final light = _buildLight();
  static final dark = _buildDark();

  static ThemeData _buildLight() {
    final scheme = ColorScheme.light(
      primary: primary,
      onPrimary: white,
      secondary: primaryLight,
      onSecondary: white,
      surface: cardLight,
      onSurface: Colors.black87,
      error: error,
      onError: white,
    );

    return _baseTheme(scheme).copyWith(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: scaffoldLight,
      cardColor: cardLight,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: white),
      ),
      inputDecorationTheme: _inputTheme(
        borderColor: primary,
        focusedColor: primary,
        labelColor: Colors.black87,
        fillColor: white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        selectedColor: primary,
        labelStyle: const TextStyle(color: Colors.black87),
        padding: const EdgeInsets.all(8),
        side: BorderSide.none,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cardLight,
        surfaceTintColor: Colors.transparent,
        shadowColor: primary.withValues(alpha: 0.16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryLight,
        linearTrackColor: primary.withValues(alpha: 0.25),
        circularTrackColor: Colors.grey.shade300,
        strokeWidth: 4,
        refreshBackgroundColor: Colors.grey.shade300,
      ),
      iconTheme: IconThemeData(color: primary),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: white,
        focusColor: primaryLight,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 32),
        unselectedIconTheme: const IconThemeData(size: 24),
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
      ),
    );
  }

  static ThemeData _buildDark() {
    final scheme = ColorScheme.dark(
      primary: primaryLight,
      onPrimary: white,
      secondary: primary,
      onSecondary: white,
      surface: cardDark,
      onSurface: Colors.white70,
      error: errorDark,
      onError: Colors.black,
    );

    return _baseTheme(scheme).copyWith(
      brightness: Brightness.dark,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: scaffoldDark,
      cardColor: cardDark,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldDark,
        foregroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      inputDecorationTheme: _inputTheme(
        borderColor: Colors.white54,
        focusedColor: primaryLight,
        labelColor: Colors.white70,
        fillColor: scaffoldDark,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade700,
        selectedColor: primaryLight,
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.all(8),
        side: BorderSide.none,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cardDark,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryLight,
        linearTrackColor: Colors.grey.shade700,
        circularTrackColor: Colors.grey.shade800,
        strokeWidth: 4,
        refreshBackgroundColor: Colors.grey.shade900,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: white,
        focusColor: primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey.shade800,
        selectedItemColor: primaryLight,
        unselectedItemColor: Colors.white54,
        selectedIconTheme: const IconThemeData(size: 32),
        unselectedIconTheme: const IconThemeData(size: 24),
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
      ),
    );
  }

  static ThemeData _baseTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: null,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: scheme.primary),
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface,
        modalBarrierColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: scheme.onInverseSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static InputDecorationTheme _inputTheme({
    required Color borderColor,
    required Color focusedColor,
    required Color labelColor,
    required Color fillColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      labelStyle: TextStyle(color: labelColor),
      floatingLabelStyle: TextStyle(
        color: focusedColor,
        fontWeight: FontWeight.w700,
      ),
      prefixIconColor: borderColor,
      suffixIconColor: borderColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusedColor, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: error, width: 1.6),
      ),
    );
  }
}
