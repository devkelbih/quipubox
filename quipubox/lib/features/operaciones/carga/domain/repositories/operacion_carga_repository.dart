import '../entities/detalle_carga.dart';
import '../entities/asignacion_directa_carga.dart';
import '../entities/detalle_carga_calidad.dart';
import '../entities/guia_operacion_carga.dart';
import '../entities/operacion_carga.dart';

abstract class OperacionCargaRepository {
  Future<List<OperacionCarga>> getAll({String? estado, DateTime? fecha});
  Future<OperacionCarga> getById(int id);
  Future<OperacionCarga> create(OperacionCarga operacion);
  Future<OperacionCarga> update(OperacionCarga operacion);
  Future<OperacionCarga> changeEstado({
    required int id,
    required String estado,
  });

  /// Eliminar una operación de carga
  Future<OperacionCarga> cancelar(int id);

  Future<OperacionCarga> finalizar(int id);
  Future<List<GuiaOperacionCarga>> generarGuias(int id);
  Future<List<GuiaOperacionCarga>> generarGuiasPorPuesto(int id);
  Future<List<DetalleCarga>> getDetalles(int operacionId);
  Future<DetalleCarga> createDetalle(
    int operacionId,
    DetalleCarga detalle, {
    AsignacionDirectaCarga? asignacionDirecta,
  });
  Future<DetalleCarga> updateDetalle(DetalleCarga detalle);
  Future<DetalleCargaCalidad> updateCalidadDetalle(DetalleCargaCalidad calidad);
  Future<void> deleteDetalle(int detalleId);
  Future<List<DetalleCargaCalidad>> getCalidadesDetalle(int detalleId);
  Future<DetalleCargaCalidad> addCalidadDetalle(DetalleCargaCalidad calidad);
  Future<List<DetalleCarga>> getDetallesPendientes();
  Future<List<DetalleCarga>> getDetallesRepartoPendientes(int operacionId);
}
