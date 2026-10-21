import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../entities/operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class UpdateOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;

  const UpdateOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<OperacionCarga> call(OperacionCarga operacion) {
    final currentUserId = currentSession.currentUserId;
    if (currentUserId == null) {
      throw const AppException('No se encontró el usuario en sesión.');
    }
    final idEmpresa = requireCurrentCompanyId(currentSession);
    if (operacion.id == null) {
      throw const AppException(
        'No se encontró el ID de la operación de carga.',
      );
    }

    return repository.update(
      operacion.copyWith(idEmpresa: idEmpresa, idEncargadoCarga: currentUserId),
    );
  }
}
