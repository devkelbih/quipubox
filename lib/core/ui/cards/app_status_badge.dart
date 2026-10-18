import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/status/app_status_colors.dart';
import 'package:quipubox/core/ui/tags/app_tag.dart';

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

    return AppTag(
      label: status.label,
      size: AppTagSize.small,
      backgroundColor: style.background,
      foregroundColor: style.foreground,
      borderColor: Colors.transparent,
    );
  }
}