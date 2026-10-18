import 'package:flutter/material.dart';
abstract class SettingsRepository { ThemeMode getThemeMode(); Future<void> saveThemeMode(ThemeMode mode); }
