import '../../../carga/domain/entities/detalle_carga.dart';
import '../../../carga/domain/entities/operacion_carga.dart';
import 'reparto.dart';

class DistribucionOperacion {
  final OperacionCarga operacion;
  final List<DetalleCarga> cargas;
  final List<Reparto> asignaciones;
  const DistribucionOperacion({
    required this.operacion,
    required this.cargas,
    required this.asignaciones,
  });
  int get cargadas => cargas.fold(0, (n, c) => n + c.cantidadJabas);
  int get productos => cargas.map((c) => c.idFruta).toSet().length;
  int get asignadas => asignaciones.fold(0, (n, a) => n + a.cantidad);
  int asignadasCarga(int? id) => asignaciones
      .where((a) => a.detalleId == id)
      .fold(0, (n, a) => n + a.cantidad);
  int get sinDestinatario => cargas.fold(
    0,
    (n, c) =>
        n + (c.cantidadJabas - asignadasCarga(c.id)).clamp(0, c.cantidadJabas),
  );
  int? get clasificadas => cargas.any((c) => c.cantidadClasificada == null)
      ? null
      : cargas.fold<int>(0, (n, c) => n + c.cantidadClasificada!);
  int? get sinClasificar => clasificadas == null
      ? null
      : cargas.fold<int>(
          0,
          (n, c) =>
              n +
              (c.cantidadJabas - c.cantidadClasificada!).clamp(
                0,
                c.cantidadJabas,
              ),
        );
  bool get excesoAsignacion =>
      cargas.any((c) => asignadasCarga(c.id) > c.cantidadJabas);
  bool get excesoClasificacion =>
      cargas.any((c) => (c.cantidadClasificada ?? 0) > c.cantidadJabas);
  int get desglosesPendientes =>
      asignaciones.where((a) => a.cantidadDesglosada != a.cantidad).length;
}
