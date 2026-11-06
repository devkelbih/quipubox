import '../../../../../core/session/current_session.dart';
import '../../../../../core/exceptions/app_exception.dart';
import '../../../../catalogos/variedades/domain/entities/variedad.dart';
import '../entities/asignacion_directa_carga.dart';
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
    Variedad? variedad,
    AsignacionDirectaCarga? asignacionDirecta,
  }) async {
    final idEmpresa = requireCurrentCompanyId(currentSession);
    if (operacionId <= 0 ||
        detalle.idClienteEmisor <= 0 ||
        detalle.idFruta <= 0 ||
        detalle.idTipoJaba <= 0) {
      throw const AppException('Selecciona emisor, fruta y tipo de jaba.');
    }
    if (detalle.cantidadJabas < 1 || detalle.cantidadJabas > 2147483647) {
      throw const AppException(
        'Ingresa una cantidad entera de jabas mayor que cero.',
      );
    }
    if (detalle.idVariedad != null &&
        (variedad == null ||
            variedad.id != detalle.idVariedad ||
            variedad.idFruta != detalle.idFruta ||
            !variedad.estado)) {
      throw const AppException(
        'La variedad debe pertenecer a la fruta seleccionada.',
      );
    }
    if (detalle.esReparto && asignacionDirecta != null) {
      throw const AppException(
        'La carga para reparto se registra sin receptor ni puesto.',
      );
    }
    if (!detalle.esReparto &&
        (asignacionDirecta == null ||
            asignacionDirecta.idClienteReceptor <= 0 ||
            asignacionDirecta.idPuesto <= 0)) {
      throw const AppException(
        'Selecciona un receptor y su puesto para la entrega directa.',
      );
    }
    final operation = await repository.getById(operacionId);
    if (!const [
      'pendiente',
      'en_curso',
      'en_transito',
    ].contains(operation.estado)) {
      throw const AppException(
        'No se puede agregar carga en el estado actual de la operación.',
      );
    }
    return repository.createDetalle(
      operacionId,
      detalle.copyWith(idEmpresa: idEmpresa, idOperacion: operacionId),
      asignacionDirecta: asignacionDirecta,
    );
  }
}
