import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/status/app_status_colors.dart';

class AppCardHeader extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? badge;

  final AppStatus? status;

  const AppCardHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final style = status != null
        ? AppStatusStyle.of(
            context,
            status!.type,
          )
        : null;

    return Row(
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

        const SizedBox(width: 14),

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