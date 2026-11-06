import '../../../../../core/exceptions/app_exception.dart';
import '../../../carga/domain/entities/detalle_carga.dart';
import '../../../carga/domain/entities/detalle_carga_calidad.dart';
import '../../../carga/domain/entities/operacion_carga.dart';
import '../../../carga/domain/usecases/get_detalles_operacion.dart';
import '../../../carga/domain/usecases/get_operacion_carga_by_id.dart';
import '../../../carga/domain/usecases/get_calidades_detalle.dart';
import '../../../../organizacion/clientes/domain/entities/cliente.dart';
import '../../../../organizacion/clientes/domain/usecases/get_clientes.dart';
import '../entities/contexto_reparto.dart';
import '../entities/reparto.dart';
import '../repositories/reparto_repository.dart';
import '../../../../organizacion/puestos/domain/entities/puesto.dart';
import '../../../../organizacion/puestos/domain/usecases/get_puestos.dart';

class GetContextoRepartoUseCase {
  final RepartoRepository repository;
  final GetOperacionCargaByIdUseCase getOperacion;
  final GetDetallesOperacionUseCase getDetalles;
  final GetCalidadesDetalleUseCase getCalidades;
  final GetClientesUseCase getClientes;
  final GetPuestosUseCase getPuestos;
  const GetContextoRepartoUseCase({
    required this.repository,
    required this.getOperacion,
    required this.getDetalles,
    required this.getCalidades,
    required this.getClientes,
    required this.getPuestos,
  });
  Future<ContextoReparto> call(int operacionId, int detalleId) async {
    final results = await Future.wait<Object>([
      getOperacion(operacionId),
      getDetalles(operacionId),
      getCalidades(detalleId),
      repository.getAll(detalleId: detalleId),
      // TODO: Reemplazar /clientes/all por consulta de receptores por sede cuando la API la permita.
      getClientes(),
      getPuestos(),
    ]);
    final detalle = (results[1] as List<DetalleCarga>)
        .where((d) => d.id == detalleId)
        .firstOrNull;
    if (detalle == null) {
      throw const AppException('La carga no pertenece a esta operación.');
    }
    final puestos = {for (final p in results[5] as List<Puesto>) p.id: p};
    final clientes = (results[4] as List<Cliente>)
        .map(
          (c) => c.copyWith(
            puestos: c.puestos
                .map((p) => p.copyWith(puesto: puestos[p.idPuesto] ?? p.puesto))
                .toList(),
          ),
        )
        .toList();
    return ContextoReparto(
      operacion: results[0] as OperacionCarga,
      detalle: detalle,
      calidades: results[2] as List<DetalleCargaCalidad>,
      repartos: results[3] as List<Reparto>,
      clientes: clientes,
    );
  }
}
