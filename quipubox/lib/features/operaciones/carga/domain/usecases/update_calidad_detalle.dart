import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../entities/detalle_carga_calidad.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class UpdateCalidadDetalleUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;
  const UpdateCalidadDetalleUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<DetalleCargaCalidad> call(
    DetalleCargaCalidad item, {
    required List<DetalleCargaCalidad> registradas,
    required int cantidadTotal,
  }) {
    final empresa = requireCurrentCompanyId(currentSession);
    if ((item.id ?? 0) <= 0 ||
        !registradas.any(
          (c) => c.id == item.id && c.idCalidad == item.idCalidad,
        )) {
      throw const AppException(
        'Selecciona una calidad registrada para editar.',
      );
    }
    final otras = registradas
        .where((c) => c.id != item.id)
        .fold<int>(0, (total, c) => total + c.cantidad);
    if (item.cantidad < 1 || item.cantidad + otras > cantidadTotal) {
      throw const AppException(
        'La cantidad debe ser mayor que cero y no superar las jabas pendientes.',
      );
    }
    final precio = item.precioUnitario;
    if (precio != null &&
        (!precio.isFinite || precio < 0 || precio > 9999999999.99)) {
      throw const AppException(
        'Ingresa un precio unitario válido mayor o igual a cero.',
      );
    }
    return repository.updateCalidadDetalle(item.copyWith(idEmpresa: empresa));
  }
}
