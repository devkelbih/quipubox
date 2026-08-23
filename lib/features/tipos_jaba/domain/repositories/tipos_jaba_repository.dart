import '../entities/tipos_jaba.dart';

abstract class TipoJabaRepository {
  Future<List<TiposJaba>> getAll();
  Future<TiposJaba> create(TiposJaba tipoJaba);
  Future<TiposJaba> update(TiposJaba tipoJaba);

  Future<bool> changeStatus({
    required int id,
    required bool estado,
  });
}
