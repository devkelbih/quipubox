import '../entities/reparto.dart';

abstract class RepartoRepository {
  Future<List<Reparto>> getAll({
    int? detalleId,
    int? receptorId,
    int? puestoId,
    String? seccion,
  });
  Future<Reparto> getById(int id);
  Future<List<Reparto>> getByDetalle(int detalleId);
  Future<void> createSimple(int detalleId, AsignacionReparto item);
  Future<void> createConCalidades(int detalleId, AsignacionReparto item);
  Future<void> createMultiple(int detalleId, List<AsignacionReparto> items);
  Future<void> update(int id, int detalleId, AsignacionReparto item);
  Future<void> delete(int id);
  Future<List<RepartoLinea>> getLineas(int id);
  Future<RepartoLinea> getLinea(int id);
  Future<void> addLinea(int id, RepartoLinea linea);
  Future<void> updateLinea(int id, RepartoLinea linea);
  Future<void> deleteLinea(int id);
}
