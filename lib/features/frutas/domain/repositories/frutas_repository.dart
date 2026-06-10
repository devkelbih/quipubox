import '../../data/models/fruta_request_model.dart';
import '../entities/fruta.dart';
abstract class FrutaRepository { Future<List<Fruta>> getAll(); Future<Fruta> create(FrutaRequestModel request); Future<Fruta> update(int id, {required FrutaRequestModel request}); Future<void> delete(int id); }
