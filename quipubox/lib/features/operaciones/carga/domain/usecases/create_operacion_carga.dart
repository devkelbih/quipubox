import '../../../../../core/session/current_session.dart';
import '../entities/operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class CreateOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;

  const CreateOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<OperacionCarga> call(OperacionCarga operacion) {
    final idEmpresa = requireCurrentCompanyId(currentSession);
    return repository.create(operacion.copyWith(idEmpresa: idEmpresa));
  }
}
