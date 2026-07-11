import 'package:flutter/material.dart';
import 'drawer_metrics.dart';
import 'drawer_styles.dart';

/// ===============================================================
/// AppDrawerSubTile
/// ---------------------------------------------------------------
/// Tile secundario para usar dentro de un tile expandible.
/// ===============================================================
class AppDrawerSubTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final bool enabled;

  const AppDrawerSubTile({
    super.key,
    required this.title,
    required this.onTap,
    this.leadingIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(top: DrawerMetrics.cardSpacing),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onTap() : null,
          borderRadius: BorderRadius.circular(
            DrawerMetrics.subCardRadius,
          ),
          child: Container(
            padding: DrawerMetrics.subTilePadding,
            decoration: DrawerStyles.subTileDecoration(theme),
            child: Row(
              children: [
                // Indicador (siempre ocupa el mismo espacio)
                SizedBox(
                  width: 18,
                  child: Center(
                    child: leadingIcon != null
                        ? Icon(
                            leadingIcon,
                            size: DrawerMetrics.statusDot,
                            color: color,
                          )
                        : Container(
                            width: DrawerMetrics.statusDot,
                            height: DrawerMetrics.statusDot,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 11),

                // Título
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: DrawerMetrics.subItemSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                // Flecha
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: DrawerMetrics.navigationIconSize,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}