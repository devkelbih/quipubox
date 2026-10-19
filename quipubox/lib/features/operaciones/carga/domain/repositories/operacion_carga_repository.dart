import '../entities/detalle_carga.dart';
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
  Future<OperacionCarga> cancelar(int id);
  Future<OperacionCarga> finalizar(int id);
  Future<List<GuiaOperacionCarga>> generarGuias(int id);
  Future<List<GuiaOperacionCarga>> generarGuiasPorPuesto(int id);
  Future<List<DetalleCarga>> getDetalles(int operacionId);
  Future<DetalleCarga> createDetalle(int operacionId, DetalleCarga detalle);
  Future<List<DetalleCarga>> getDetallesPendientes();
  Future<List<DetalleCarga>> getDetallesRepartoPendientes(int operacionId);
}
