import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/status/app_status_colors.dart';

class AppCardHeader extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? badge;
  final Widget? menu;

  final AppStatus? status;

  const AppCardHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    this.status,
    this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final style = status != null
        ? AppStatusStyle.fromScheme(scheme, status!.type)
        : null;

    return LayoutBuilder(
      builder: (context, constraints) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: style?.background ?? scheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: IconTheme(
              data: IconThemeData(
                color: style?.foreground ?? scheme.primary,
                size: 20,
              ),
              child: icon,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: title,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                if (subtitle?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 3),
                  Tooltip(
                    message: subtitle!,
                    child: Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (menu != null || badge != null) ...[
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.48,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (badge != null) Flexible(child: badge!),
                  if (menu != null && badge != null) const SizedBox(width: 4),
                  if (menu != null) menu!,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
