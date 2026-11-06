import '../../domain/entities/reparto.dart';
import '../../domain/repositories/reparto_repository.dart';
import '../datasources/reparto_remote_data_source.dart';
import '../models/reparto_model.dart';

class RepartoRepositoryImpl implements RepartoRepository {
  final RepartoRemoteDataSource remote;
  const RepartoRepositoryImpl(this.remote);
  @override
  Future<List<Reparto>> getAll({
    int? detalleId,
    int? receptorId,
    int? puestoId,
    String? seccion,
  }) async => (await remote.getAll({
    if (detalleId != null) 'id_detalle_carga': '$detalleId',
    if (receptorId != null) 'id_cliente_receptor': '$receptorId',
    if (puestoId != null) 'id_puesto': '$puestoId',
    if (seccion != null) 'seccion': seccion,
  })).map((m) => m.toEntity()).toList();
  @override
  Future<Reparto> getById(int id) async =>
      (await remote.getById(id)).toEntity();
  @override
  Future<List<Reparto>> getByDetalle(int id) async =>
      (await remote.getByDetalle(id)).map((m) => m.toEntity()).toList();
  @override
  Future<void> createSimple(int id, AsignacionReparto item) =>
      remote.create('', {
        'id_detalle_carga': id,
        ...AsignacionRepartoModel.toJson(item, simple: true),
      });
  @override
  Future<void> createConCalidades(int id, AsignacionReparto item) =>
      remote.create('/from-calidades', {
        'id_detalle_carga': id,
        ...AsignacionRepartoModel.toJson(item),
      });
  @override
  Future<void> createMultiple(int id, List<AsignacionReparto> items) =>
      remote.create('/from-calidades-multiple', {
        'id_detalle_carga': id,
        'asignaciones': items
            .map((a) => AsignacionRepartoModel.toJson(a))
            .toList(),
      });
  @override
  Future<void> update(int id, int detalleId, AsignacionReparto item) =>
      remote.update(id, {
        'id_detalle_carga': detalleId,
        ...AsignacionRepartoModel.toJson(item, update: true),
      });
  @override
  Future<void> delete(int id) => remote.delete(id);
  @override
  Future<List<RepartoLinea>> getLineas(int id) async =>
      (await remote.getLineas(id)).map((m) => m.toEntity()).toList();
  @override
  Future<RepartoLinea> getLinea(int id) async =>
      (await remote.getLinea(id)).toEntity();
  @override
  Future<void> addLinea(int id, RepartoLinea l) =>
      remote.addLinea(id, RepartoLineaModel.toJson(l));
  @override
  Future<void> updateLinea(int id, RepartoLinea l) =>
      remote.updateLinea(id, RepartoLineaModel.toJson(l, update: true));
  @override
  Future<void> deleteLinea(int id) => remote.deleteLinea(id);
}
