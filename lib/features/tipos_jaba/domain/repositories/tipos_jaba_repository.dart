import '../../data/models/tipos_jaba_request_model.dart';
import '../entities/tipos_jaba.dart';
abstract class TipoJabaRepository { Future<List<TipoJaba>> getAll(); Future<TipoJaba> create(TipoJabaRequestModel request); Future<TipoJaba> update(int id, {required TipoJabaRequestModel request}); Future<void> delete(int id); }
