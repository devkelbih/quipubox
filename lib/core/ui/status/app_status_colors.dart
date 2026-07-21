import 'package:flutter/material.dart';

enum AppStatusType {
  success,
  warning,
  danger,
  info,
  neutral,
}

class AppStatusStyle {
  final Color foreground;
  final Color background;

  const AppStatusStyle({
    required this.foreground,
    required this.background,
  });

  static AppStatusStyle of(
    BuildContext context,
    AppStatusType type,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return switch (type) {
      AppStatusType.success => AppStatusStyle(
        foreground: scheme.onPrimaryContainer,
        background: scheme.primaryContainer,
      ),

      AppStatusType.danger => AppStatusStyle(
        foreground: scheme.onErrorContainer,
        background: scheme.errorContainer,
      ),

      AppStatusType.warning => AppStatusStyle(
        foreground: scheme.onTertiaryContainer,
        background: scheme.tertiaryContainer,
      ),

      AppStatusType.info => AppStatusStyle(
        foreground: scheme.onSecondaryContainer,
        background: scheme.secondaryContainer,
      ),

      AppStatusType.neutral => AppStatusStyle(
        foreground: scheme.onSurfaceVariant,
        background: scheme.surfaceContainerHighest,
      ),
    };
  }
}