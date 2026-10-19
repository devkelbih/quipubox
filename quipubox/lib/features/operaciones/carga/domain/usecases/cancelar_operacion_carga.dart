import '../../../../../core/session/current_session.dart';
import '../entities/operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class CancelarOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;

  const CancelarOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<OperacionCarga> call(int id) {
    requireCurrentCompanyId(currentSession);
    return repository.cancelar(id);
  }
}
