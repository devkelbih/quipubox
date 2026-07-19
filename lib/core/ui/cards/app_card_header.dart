import 'package:flutter/material.dart';

/// ===============================================================
/// AppCardHeader
/// ---------------------------------------------------------------
/// Encabezado reutilizable para las tarjetas de Quipubox.
///
/// Se compone de:
///
/// • Icono representativo.
/// • Título.
/// • Subtítulo (opcional).
/// • Badge o acción (opcional).
///
/// No conoce el contenido del Body ni las acciones.
/// ===============================================================
class AppCardHeader extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? badge;

  const AppCardHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================================================
        // Icono
        // =========================================================
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(
              color: scheme.primary,
              size: 20,
            ),
            child: icon,
          ),
        ),

        const SizedBox(width: 14),

        // =========================================================
        // Información
        // =========================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (badge != null) ...[
          const SizedBox(width: 12),
          badge!,
        ],
      ],
    );
  }
}