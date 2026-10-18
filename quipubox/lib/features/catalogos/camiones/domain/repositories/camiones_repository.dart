import '../entities/camion.dart';

abstract class CamionRepository {
  Future<List<Camion>> getAll();
  Future<Camion> create(Camion camion);
  Future<Camion> update(Camion camion);
  Future<bool> changeStatus({required int id, required bool estado});
}
