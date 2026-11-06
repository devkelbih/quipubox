import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class DeleteDetalleOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;
  const DeleteDetalleOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<void> call({required int detalleId, required String estado}) {
    requireCurrentCompanyId(currentSession);
    if (detalleId <= 0) {
      throw const AppException('No se encontró el detalle de carga.');
    }
    if (!const ['pendiente', 'en_curso', 'en_transito'].contains(estado)) {
      throw const AppException(
        'No se puede eliminar un detalle en el estado actual de la operación.',
      );
    }
    return repository.deleteDetalle(detalleId);
  }
}
