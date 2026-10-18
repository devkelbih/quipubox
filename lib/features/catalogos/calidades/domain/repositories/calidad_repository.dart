import '../entities/calidad.dart';

abstract class CalidadRepository {
  Future<List<Calidad>> getAll();
  Future<Calidad> create(Calidad calidad);
  Future<Calidad> update(Calidad calidad);

  Future<bool> changeStatus({
    required int id,
    required bool estado,
  });
}
