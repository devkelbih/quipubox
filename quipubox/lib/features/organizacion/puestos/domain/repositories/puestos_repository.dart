import '../entities/puesto.dart';

abstract class PuestoRepository {
  Future<List<Puesto>> getAll();
  Future<Puesto> create(Puesto puesto);
  Future<Puesto> update(Puesto puesto);

  Future<bool> changeStatus({required int id, required bool estado});
}
