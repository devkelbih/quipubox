import '../../../../../core/exceptions/app_exception.dart';
import '../../../../../core/session/current_session.dart';
import '../../../carga/domain/usecases/operacion_carga_usecase_helpers.dart';
import '../entities/reparto.dart';
import '../repositories/reparto_repository.dart';
import 'get_contexto_reparto.dart';
import 'reparto_validation.dart';

class SaveAsignacionesRepartoUseCase {
  final RepartoRepository repository;
  final GetContextoRepartoUseCase getContexto;
  final CurrentSession currentSession;
  const SaveAsignacionesRepartoUseCase({
    required this.repository,
    required this.getContexto,
    required this.currentSession,
  });
  Future<void> call(
    int operacionId,
    int detalleId,
    List<AsignacionReparto> items,
  ) async {
    final idEmpresa = requireCurrentCompanyId(currentSession);
    final c = await getContexto(operacionId, detalleId);
    requireEditable(c);
    if (items.isEmpty) {
      throw const AppException('Agrega al menos una asignación.');
    }
    if (!c.detalle.esReparto &&
        (c.repartos.isNotEmpty ||
            items.length != 1 ||
            items.single.cantidad != c.detalle.cantidadJabas)) {
      throw const AppException(
        'La entrega directa debe completarse sobre su asignación existente, sin duplicarla.',
      );
    }
    if (c.asignadas + items.fold<int>(0, (n, a) => n + a.cantidad) >
        c.detalle.cantidadJabas) {
      throw const AppException('Las asignaciones superan las jabas cargadas.');
    }
    final nuevas = <int, int>{};
    for (final a in items) {
      validateDestino(c, a);
      if (a.lineas.isNotEmpty &&
          a.lineas.fold<int>(0, (n, l) => n + l.cantidad) != a.cantidad) {
        throw const AppException(
          'El desglose no coincide con la cantidad asignada.',
        );
      }
      if (a.lineas.map((l) => l.idCalidadCarga).toSet().length !=
          a.lineas.length) {
        throw const AppException('Una calidad está repetida en la asignación.');
      }
      for (final l in a.lineas) {
        if (l.cantidad < 1 ||
            !c.calidades.any((q) => q.id == l.idCalidadCarga)) {
          throw const AppException(
            'Selecciona una calidad válida de esta carga.',
          );
        }
        validatePrecio(l.precio);
        nuevas.update(
          l.idCalidadCarga,
          (n) => n + l.cantidad,
          ifAbsent: () => l.cantidad,
        );
      }
    }
    for (final entry in nuevas.entries) {
      if (entry.value > c.saldoCalidad(entry.key)) {
        throw const AppException(
          'La cantidad solicitada supera el saldo disponible de una calidad. Actualiza los saldos.',
        );
      }
    }
    if (items.length > 1) {
      if (items.any((a) => a.lineas.isEmpty)) {
        throw const AppException(
          'Las asignaciones múltiples necesitan un desglose por calidad.',
        );
      }
      await repository.createMultiple(
        detalleId,
        items.map((a) => a.copyWith(idEmpresa: idEmpresa)).toList(),
      );
    } else if (items.single.lineas.isEmpty) {
      await repository.createSimple(
        detalleId,
        items.single.copyWith(idEmpresa: idEmpresa),
      );
    } else {
      await repository.createConCalidades(
        detalleId,
        items.single.copyWith(idEmpresa: idEmpresa),
      );
    }
  }
}
