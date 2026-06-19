import '../entities/variedad.dart';

abstract class VariedadRepository {
  Future<List<Variedad>> getAll();
  Future<List<Variedad>> getByFruta(int frutaId);
  Future<Variedad> create(Variedad variedad);
  Future<Variedad> update(Variedad variedad);

  Future<Variedad> changeStatus({
    required int id,
    required bool estado,
  });
}
