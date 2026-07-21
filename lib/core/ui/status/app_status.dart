import 'package:quipubox/core/ui/status/app_status_colors.dart';

class AppStatus {
  final String label;
  final AppStatusType type;

  const AppStatus({
    required this.label,
    required this.type,
  });

  factory AppStatus.active(bool active) {
    return AppStatus(
      label: active ? 'Activo' : 'Inactivo',
      type: active
          ? AppStatusType.success
          : AppStatusType.danger,
    );
  }
}