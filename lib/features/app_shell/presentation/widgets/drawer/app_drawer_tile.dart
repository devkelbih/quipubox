import 'package:flutter/material.dart';
import 'drawer_metrics.dart';
import 'drawer_styles.dart';

/// ===============================================================
/// AppDrawerTile
/// ---------------------------------------------------------------
/// Tile principal del drawer. Puede ser simple o expandible.
/// ===============================================================
class AppDrawerTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final List<Widget>? children;
  final bool initiallyExpanded;

  const AppDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<AppDrawerTile> createState() => _AppDrawerTileState();
}

class _AppDrawerTileState extends State<AppDrawerTile>
    with TickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  bool get _isExpandable =>
      widget.children != null && widget.children!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: DrawerMetrics.cardSpacing),
      decoration: DrawerStyles.cardDecoration(theme),
      child: Column(
        children: [
          // Header del tile
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(DrawerMetrics.cardRadius),
              onTap: () {
                if (_isExpandable) {
                  _toggleExpansion();
                } else {
                  widget.onTap?.call();
                }
              },
              child: Padding(
                padding: DrawerMetrics.tilePadding,
                child: Row(
                  children: [
                    // Icono
                    Container(
                      width: DrawerMetrics.iconContainerSize,
                      height: DrawerMetrics.iconContainerSize,
                      decoration: DrawerStyles.iconContainer(theme, color),
                      child: Icon(
                        widget.icon,
                        color: color,
                        size: DrawerMetrics.iconSize,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Título y subtítulo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: DrawerMetrics.titleSize,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              widget.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: DrawerMetrics.subtitleSize,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Flecha (solo si es expandible)
                    if (_isExpandable)
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: DrawerMetrics.navigationIconSize,
                          color: _expanded
                              ? color
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    // Flecha simple (si es un tile simple)
                    if (!_isExpandable && widget.onTap != null)
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
          // Children expandibles
          if (_isExpandable)
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _expanded
                    ? Padding(
                        padding: DrawerMetrics.childrenPadding,
                        child: Column(children: widget.children!),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _expanded = !_expanded;
    });
  }
}
