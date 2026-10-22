import '../../../../../core/ui/status/app_status.dart';
import '../../../../../core/ui/status/app_status_colors.dart';
import '../../domain/enums/estado_operacion_carga.dart';

/// Presentación compartida del estado, sin acoplar el enum de dominio a la UI.
extension EstadoOperacionCargaUi on EstadoOperacionCarga {
  AppStatus get status => AppStatus(
    label: label,
    type: switch (this) {
      EstadoOperacionCarga.pendiente => AppStatusType.warning,
      EstadoOperacionCarga.enCurso ||
      EstadoOperacionCarga.enTransito => AppStatusType.info,
      EstadoOperacionCarga.repartiendo => AppStatusType.success,
      EstadoOperacionCarga.completado => AppStatusType.neutral,
    },
  );
}
