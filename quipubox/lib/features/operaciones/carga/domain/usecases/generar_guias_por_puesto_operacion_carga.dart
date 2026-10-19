import '../../../../../core/session/current_session.dart';
import '../entities/guia_operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class GenerarGuiasPorPuestoOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;

  const GenerarGuiasPorPuestoOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<List<GuiaOperacionCarga>> call(int id) {
    requireCurrentCompanyId(currentSession);
    return repository.generarGuiasPorPuesto(id);
  }
}
