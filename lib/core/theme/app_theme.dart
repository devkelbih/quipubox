import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();
  static final light = _build(ColorScheme.fromSeed(seedColor: const Color(0xFF1E5AA8), brightness: Brightness.light));
  static final dark = _build(ColorScheme.fromSeed(seedColor: const Color(0xFF4DA3FF), brightness: Brightness.dark));

  static ThemeData _build(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    appBarTheme: AppBarTheme(centerTitle: false, elevation: 0, backgroundColor: scheme.surface, foregroundColor: scheme.onSurface),
    cardTheme: CardThemeData(elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), color: scheme.surfaceContainerLow),
    inputDecorationTheme: InputDecorationTheme(filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
  );
}
