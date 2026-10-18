import 'package:flutter/material.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
class SettingsRepositoryImpl implements SettingsRepository { final SettingsLocalDataSource localDataSource; SettingsRepositoryImpl(this.localDataSource); @override ThemeMode getThemeMode() => localDataSource.getThemeMode(); @override Future<void> saveThemeMode(ThemeMode mode) => localDataSource.saveThemeMode(mode); }
