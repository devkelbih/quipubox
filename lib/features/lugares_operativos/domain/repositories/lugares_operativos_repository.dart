import '../../data/models/lugar_operativo_request_model.dart';
import '../entities/lugar_operativo.dart';
abstract class LugarOperativoRepository { Future<List<LugarOperativo>> getAll(); Future<LugarOperativo> create(LugarOperativoRequestModel request); Future<LugarOperativo> update(int id, {required LugarOperativoRequestModel request}); Future<void> delete(int id); }
