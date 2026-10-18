import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsLocalDataSource {
  final SharedPreferences preferences;
  static const _key = 'theme_mode';
  SettingsLocalDataSource(this.preferences);
  ThemeMode getThemeMode() => switch (preferences.getString(_key) ?? 'system') { 'light' => ThemeMode.light, 'dark' => ThemeMode.dark, _ => ThemeMode.system };
  Future<void> saveThemeMode(ThemeMode mode) => preferences.setString(_key, mode.name);
}
