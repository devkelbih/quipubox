import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../../../carga/domain/usecases/operacion_carga_usecase_helpers.dart';
import '../entities/reparto.dart';
import '../repositories/reparto_repository.dart';
import 'get_contexto_reparto.dart';
import 'reparto_validation.dart';

class UpdateRepartoUseCase {
  final RepartoRepository repository;
  final GetContextoRepartoUseCase getContexto;
  final CurrentSession currentSession;
  const UpdateRepartoUseCase({
    required this.repository,
    required this.getContexto,
    required this.currentSession,
  });
  Future<void> call(
    int operationId,
    int detailId,
    int id,
    AsignacionReparto a,
  ) async {
    final idEmpresa = requireCurrentCompanyId(currentSession);
    final c = await getContexto(operationId, detailId);
    final original = requireItem(c, id);
    validateDestino(c, a, original: original);
    if (a.cantidad < original.cantidadDesglosada ||
        c.asignadas - original.cantidad + a.cantidad >
            c.detalle.cantidadJabas) {
      throw const AppException(
        'La cantidad debe cubrir su desglose y respetar el total cargado.',
      );
    }
    if (!c.detalle.esReparto && a.cantidad != c.detalle.cantidadJabas) {
      throw const AppException(
        'La entrega directa debe conservar toda la cantidad cargada.',
      );
    }
    await repository.update(id, detailId, a.copyWith(idEmpresa: idEmpresa));
  }
}
