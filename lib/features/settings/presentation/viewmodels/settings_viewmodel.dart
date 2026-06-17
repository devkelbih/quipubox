import 'package:flutter/material.dart';

import '../../../../core/state/safe_change_notifier.dart';
import '../../domain/usecases/get_theme_mode_usecase.dart';
import '../../domain/usecases/save_theme_mode_usecase.dart';

class SettingsViewModel extends SafeChangeNotifier {
  final GetThemeModeUseCase getThemeModeUseCase;
  final SaveThemeModeUseCase saveThemeModeUseCase;

  SettingsViewModel({
    required this.getThemeModeUseCase,
    required this.saveThemeModeUseCase,
  }) {
    themeMode = getThemeModeUseCase();
  }

  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  bool isEffectiveDarkMode(BuildContext context) {
    if (themeMode == ThemeMode.dark) return true;
    if (themeMode == ThemeMode.light) return false;

    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    await saveThemeModeUseCase(mode);
  }

  Future<void> toggleDarkMode(BuildContext context) {
    final isDarkNow = isEffectiveDarkMode(context);
    return setThemeMode(isDarkNow ? ThemeMode.light : ThemeMode.dark);
  }
}