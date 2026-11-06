import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../../../../catalogos/variedades/domain/entities/variedad.dart';
import '../entities/detalle_carga.dart';
import '../repositories/operacion_carga_repository.dart';
import 'operacion_carga_usecase_helpers.dart';

class UpdateDetalleOperacionCargaUseCase {
  final OperacionCargaRepository repository;
  final CurrentSession currentSession;
  const UpdateDetalleOperacionCargaUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<DetalleCarga> call(DetalleCarga detalle, {Variedad? variedad}) async {
    final empresa = requireCurrentCompanyId(currentSession);
    if ((detalle.id ?? 0) <= 0 ||
        (detalle.idOperacion ?? 0) <= 0 ||
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
        (variedad?.id != detalle.idVariedad ||
            variedad?.idFruta != detalle.idFruta)) {
      throw const AppException(
        'La variedad debe pertenecer a la fruta seleccionada.',
      );
    }
    final operation = await repository.getById(detalle.idOperacion!);
    if (!const [
      'pendiente',
      'en_curso',
      'en_transito',
    ].contains(operation.estado)) {
      throw const AppException(
        'No se puede editar carga en el estado actual de la operación.',
      );
    }
    final calidades = await repository.getCalidadesDetalle(detalle.id!);
    if (calidades.fold<int>(0, (n, c) => n + c.cantidad) >
        detalle.cantidadJabas) {
      throw const AppException(
        'La cantidad cargada no puede ser menor que las jabas ya clasificadas.',
      );
    }
    return repository.updateDetalle(detalle.copyWith(idEmpresa: empresa));
  }
}
