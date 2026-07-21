import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/status/app_status_colors.dart';

class AppStatusBadge extends StatelessWidget {
  final AppStatus status;

  const AppStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppStatusStyle.of(
      context,
      status.type,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: style.foreground,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: .15,
          height: 1,
        ),
      ),
    );
  }
}