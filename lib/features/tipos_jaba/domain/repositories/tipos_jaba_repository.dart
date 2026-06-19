import '../entities/tipos_jaba.dart';

abstract class TipoJabaRepository {
  Future<List<TipoJaba>> getAll();
  Future<TipoJaba> create(TipoJaba tipoJaba);
  Future<TipoJaba> update(TipoJaba tipoJaba);

  Future<TipoJaba> changeStatus({
    required int id,
    required bool estado,
  });
}
