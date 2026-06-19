import '../entities/fruta.dart';

abstract class FrutaRepository {
  Future<List<Fruta>> getAll();
  Future<Fruta> create(Fruta fruta);
  Future<Fruta> update(Fruta fruta);

  Future<Fruta> changeStatus({
    required int id,
    required bool estado,
  });
}
