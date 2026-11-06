import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../entities/detalle_carga_calidad.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class AddCalidadDetalleUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;
  const AddCalidadDetalleUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<DetalleCargaCalidad> call(
    DetalleCargaCalidad calidad, {
    required List<DetalleCargaCalidad> registradas,
    required int cantidadTotal,
  }) {
    final idEmpresa = requireCurrentCompanyId(currentSession);
    if (calidad.idDetalleCarga <= 0 || calidad.idCalidad <= 0) {
      throw const AppException('Selecciona una calidad para este detalle.');
    }
    if (calidad.cantidad < 1) {
      throw const AppException(
        'La cantidad debe ser un número entero mayor que cero.',
      );
    }
    final precio = calidad.precioUnitario;
    if (precio != null &&
        (!precio.isFinite || precio < 0 || precio > 9999999999.99)) {
      throw const AppException(
        'Ingresa un precio unitario válido mayor o igual a cero.',
      );
    }
    if (registradas.any((item) => item.idCalidad == calidad.idCalidad)) {
      throw const AppException(
        'Esta calidad ya está registrada en el detalle.',
      );
    }
    final asignadas = registradas.fold<int>(
      0,
      (total, item) => total + item.cantidad,
    );
    if (cantidadTotal < 1 || asignadas + calidad.cantidad > cantidadTotal) {
      throw const AppException(
        'La cantidad por calidades no puede superar las jabas cargadas.',
      );
    }
    return repository.addCalidadDetalle(calidad.copyWith(idEmpresa: idEmpresa));
  }
}
