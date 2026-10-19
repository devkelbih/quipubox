import '../../../../../core/session/current_session.dart';
import '../entities/detalle_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class CreateDetalleOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;

  const CreateDetalleOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<DetalleCarga> call({
    required int operacionId,
    required DetalleCarga detalle,
  }) {
    final idEmpresa = requireCurrentCompanyId(currentSession);
    return repository.createDetalle(
      operacionId,
      detalle.copyWith(idEmpresa: idEmpresa, idOperacion: operacionId),
    );
  }
}
