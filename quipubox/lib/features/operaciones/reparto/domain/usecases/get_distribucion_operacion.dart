import '../../../carga/domain/entities/detalle_carga.dart';
import '../../../carga/domain/entities/operacion_carga.dart';
import '../../../carga/domain/usecases/get_operacion_carga_by_id.dart';
import '../../../carga/domain/usecases/get_detalles_operacion.dart';
import '../entities/distribucion_operacion.dart';
import '../entities/reparto.dart';
import 'get_repartos.dart';

class GetDistribucionOperacionUseCase {
  final GetOperacionCargaByIdUseCase getOperacion;
  final GetDetallesOperacionUseCase getCargas;
  final GetRepartosUseCase getRepartos;
  const GetDistribucionOperacionUseCase({
    required this.getOperacion,
    required this.getCargas,
    required this.getRepartos,
  });
  Future<DistribucionOperacion> call(int id) async {
    final results = await Future.wait<Object>([
      getOperacion(id),
      getCargas(id),
      getRepartos(),
    ]);
    final cargas = results[1] as List<DetalleCarga>;
    final ids = cargas.map((c) => c.id).whereType<int>().toSet();
    // La API aún no filtra ítems por operación; no consultar cada carga por separado.
    final asignaciones = (results[2] as List<Reparto>)
        .where((a) => ids.contains(a.detalleId))
        .toList();
    return DistribucionOperacion(
      operacion: results[0] as OperacionCarga,
      cargas: cargas,
      asignaciones: asignaciones,
    );
  }
}
