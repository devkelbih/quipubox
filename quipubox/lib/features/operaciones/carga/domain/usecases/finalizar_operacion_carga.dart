import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../entities/operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class FinalizarOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;

  const FinalizarOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<OperacionCarga> call(int id) async {
    requireCurrentCompanyId(currentSession);
    final detalles = await repository.getDetalles(id);
    if (detalles.isEmpty) {
      throw const AppException(
        'La operación debe tener al menos un detalle de carga para finalizar.',
      );
    }

    return repository.finalizar(id);
  }
}
