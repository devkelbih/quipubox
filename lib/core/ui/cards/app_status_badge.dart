import 'package:flutter/material.dart';

/// ===============================================================
/// AppStatusBadge
/// ---------------------------------------------------------------
/// Badge reutilizable para representar estados de cualquier
/// elemento de la aplicación.
///
/// Uso más común:
///
/// AppStatusBadge.active(item.estado)
///
/// Uso personalizado:
///
/// AppStatusBadge(
///   label: 'Pendiente',
///   type: AppStatusType.warning,
/// )
/// ===============================================================

enum AppStatusType {
  success,
  warning,
  danger,
  info,
  neutral,
}

class AppStatusBadge extends StatelessWidget {
  final String label;
  final AppStatusType type;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  /// Constructor para estados Activo / Inactivo.
  factory AppStatusBadge.active(
    bool active, {
    Key? key,
  }) {
    return AppStatusBadge(
      key: key,
      label: active ? 'Activo' : 'Inactivo',
      type: active
          ? AppStatusType.success
          : AppStatusType.danger,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (
      foregroundColor,
      backgroundColor,
    ) = switch (type) {
      AppStatusType.success => (
        scheme.onPrimaryContainer,
        scheme.primaryContainer,
      ),

      AppStatusType.warning => (
        scheme.onTertiaryContainer,
        scheme.tertiaryContainer,
      ),

      AppStatusType.danger => (
        scheme.onErrorContainer,
        scheme.errorContainer,
      ),

      AppStatusType.info => (
        scheme.onSecondaryContainer,
        scheme.secondaryContainer,
      ),

      AppStatusType.neutral => (
        scheme.onSurfaceVariant,
        scheme.surfaceContainerHighest,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.15,
          height: 1,
        ),
      ),
    );
  }
}