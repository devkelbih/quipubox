import '../entities/sede.dart';

abstract class SedeRepository {
  Future<List<Sede>> getAll();

  Future<Sede> create(Sede sede);

  Future<Sede> update(Sede sede);

  Future<bool> changeStatus({required int id, required bool estado});
}
