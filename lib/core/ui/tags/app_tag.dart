import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/tags/app_tag_metrics.dart';

enum AppTagSize { small, medium, large }

class AppTag extends StatelessWidget {
  final String label;
  final IconData? icon;

  final AppTagSize size;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  /// Indica si el tag se encuentra seleccionado.
  final bool selected;

  const AppTag({
    super.key,
    required this.label,
    this.icon,
    this.size = AppTagSize.small,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final metrics = AppTagMetrics.fromSize(size);

    final Color fg = foregroundColor ??
        (selected
            ? colors.onPrimaryContainer
            : colors.onSurfaceVariant);

    final Color bg = backgroundColor ??
        (selected
            ? colors.primaryContainer
            : colors.surfaceContainerHighest);

    final Color border = borderColor ??
        (selected
            ? colors.primary
            : colors.onSurfaceVariant);

    return Container(
      padding: metrics.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(metrics.radius),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: metrics.iconSize,
              color: fg,
            ),
            const SizedBox(width: 6),
          ],

          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: metrics.fontSize,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}