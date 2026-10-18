import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';
class GetThemeModeUseCase { final SettingsRepository repository; GetThemeModeUseCase(this.repository); ThemeMode call() => repository.getThemeMode(); }
