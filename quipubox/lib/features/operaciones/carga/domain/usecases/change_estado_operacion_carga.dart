import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../entities/operacion_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class ChangeEstadoOperacionCargaUseCase {
  static const estadosPermitidos = {
    'pendiente',
    'en_curso',
    'repartiendo',
    'cancelada',
  };

  final OperacionCargaRepository repository;
  final CurrentSession currentSession;

  const ChangeEstadoOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<OperacionCarga> call({required int id, required String estado}) {
    requireCurrentCompanyId(currentSession);
    if (!estadosPermitidos.contains(estado)) {
      throw const AppException(
        'El estado de la operación de carga no es válido.',
      );
    }

    return repository.changeEstado(id: id, estado: estado);
  }
}
