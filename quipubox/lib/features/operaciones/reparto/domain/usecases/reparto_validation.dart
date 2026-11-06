import '../../../../../core/exceptions/app_exception.dart';
import '../entities/contexto_reparto.dart';
import '../entities/reparto.dart';

void requireEditable(ContextoReparto c) {
  if (!c.editable) {
    throw const AppException('La operación ya no permite modificar repartos.');
  }
}

void validateDestino(
  ContextoReparto c,
  AsignacionReparto a, {
  Reparto? original,
}) {
  if (a.receptorId <= 0 || a.puestoId <= 0) {
    throw const AppException('Selecciona receptor y puesto.');
  }
  final mismaAsignacion =
      original?.receptorId == a.receptorId &&
      original?.puestoId == a.puestoId &&
      original?.seccion == a.seccion;
  if (!mismaAsignacion &&
      (!c.receptores.any((r) => r.id == a.receptorId) ||
          !c
              .puestos(a.receptorId)
              .any(
                (p) =>
                    p.idPuesto == a.puestoId && p.seccion?.value == a.seccion,
              ))) {
    throw const AppException(
      'Selecciona un receptor y su puesto activo en la sede de destino.',
    );
  }
  if (a.cantidad < 1 ||
      a.cantidad > 2147483647 ||
      (a.orden != null && a.orden! < 1)) {
    throw const AppException(
      'La cantidad y el orden deben ser enteros mayores que cero.',
    );
  }
}

void validatePrecio(double? precio) {
  if (precio != null &&
      (!precio.isFinite || precio < 0 || precio > 9999999999.99)) {
    throw const AppException('Ingresa un precio válido mayor o igual a cero.');
  }
}

Reparto requireItem(ContextoReparto c, int id) {
  requireEditable(c);
  final item = c.repartos.where((r) => r.id == id).firstOrNull;
  if (item == null) {
    throw const AppException('La asignación ya no está disponible.');
  }
  if (item.protegido) {
    throw const AppException(
      'Esta asignación tiene entregas o una guía emitida y no se puede modificar desde repartos.',
    );
  }
  return item;
}
