import '../entities/variedad.dart';

abstract class VariedadRepository {
  Future<List<Variedad>> getAll();
  Future<Variedad> create(Variedad variedad);
  Future<Variedad> update(Variedad variedad);

  Future<bool> changeStatus({required int id, required bool estado});
}
