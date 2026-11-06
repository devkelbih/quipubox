import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../../../carga/domain/usecases/operacion_carga_usecase_helpers.dart';
import '../entities/reparto.dart';
import '../repositories/reparto_repository.dart';
import 'get_contexto_reparto.dart';
import 'reparto_validation.dart';

class SaveLineaRepartoUseCase {
  final RepartoRepository repository;
  final GetContextoRepartoUseCase getContexto;
  final CurrentSession currentSession;
  const SaveLineaRepartoUseCase({
    required this.repository,
    required this.getContexto,
    required this.currentSession,
  });
  Future<void> call(
    int operationId,
    int detailId,
    int itemId,
    RepartoLinea l,
  ) async {
    final idEmpresa = requireCurrentCompanyId(currentSession);
    final c = await getContexto(operationId, detailId);
    final item = requireItem(c, itemId);
    final original = l.id == null
        ? null
        : item.lineas.where((old) => old.id == l.id).firstOrNull;
    if (l.id != null &&
        (original == null || original.idCalidadCarga != l.idCalidadCarga)) {
      throw const AppException('La línea ya no pertenece a esta asignación.');
    }
    if (l.id == null &&
        item.lineas.any((old) => old.idCalidadCarga == l.idCalidadCarga)) {
      throw const AppException('Esta calidad ya está agregada. Usa editar.');
    }
    if (l.cantidad < 1 ||
        !c.calidades.any((q) => q.id == l.idCalidadCarga) ||
        l.cantidad > c.saldoCalidad(l.idCalidadCarga, excluirLinea: l.id)) {
      throw const AppException(
        'La cantidad supera el saldo disponible de esta calidad.',
      );
    }
    if (item.cantidadDesglosada - (original?.cantidad ?? 0) + l.cantidad >
        item.cantidad) {
      throw const AppException(
        'El desglose supera la cantidad asignada. Ajusta primero la asignación.',
      );
    }
    validatePrecio(l.precio);
    if (l.id == null) {
      await repository.addLinea(itemId, l.copyWith(idEmpresa: idEmpresa));
    } else {
      await repository.updateLinea(l.id!, l.copyWith(idEmpresa: idEmpresa));
    }
  }
}
