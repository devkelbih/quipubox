import 'package:flutter/material.dart';

/// ===============================================================
/// AppCardInfoRow
/// ---------------------------------------------------------------
/// Fila reutilizable para representar información dentro de una
/// AppCard.
///
/// Ejemplos:
///
/// 🌱  Variedades
///     8 registradas
///
/// 📄  Descripción
///     Fruta cítrica de pulpa amarilla.
///
/// 🚚  Capacidad
///     25 TN
/// ===============================================================
class AppCardInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AppCardInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: scheme.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}