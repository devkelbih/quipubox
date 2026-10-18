import '../entities/lugar_operativo.dart';

abstract class LugarOperativoRepository {
  Future<List<LugarOperativo>> getAll();
  Future<LugarOperativo> create(LugarOperativo lugarOperativo);
  Future<LugarOperativo> update(LugarOperativo lugarOperativo);
  Future<bool> changeStatus({required int id, required bool estado});
}
