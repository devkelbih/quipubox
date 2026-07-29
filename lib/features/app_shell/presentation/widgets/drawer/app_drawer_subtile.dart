import 'package:flutter/material.dart';
import 'drawer_metrics.dart';
import 'drawer_styles.dart';

/// ===============================================================
/// AppDrawerSubTile (Diseño Minimalista y Limpio)
/// ===============================================================
class AppDrawerSubTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool enabled;

  const AppDrawerSubTile({
    super.key,
    required this.title,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Padding(
      // Sangría para encoger la tarjeta y marcar nivel
      padding: const EdgeInsets.only(
        top: DrawerMetrics.cardSpacing,
        left: 12.0, // Sangría sutil
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onTap() : null,
          borderRadius: BorderRadius.circular(DrawerMetrics.subCardRadius),
          child: Container(
            padding: DrawerMetrics.subTilePadding,
            decoration: DrawerStyles.subTileDecoration(theme),
            child: Row(
              children: [
                // 💡 SOLO LA BARRA VERTICAL (Barra accent)
                // Se eliminó el círculo por completo.
                Container(
                  width: 3.5,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(width: 12),

                // Título
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: DrawerMetrics.subItemSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}