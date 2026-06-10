import '../../data/models/sede_request_model.dart';
import '../entities/sede.dart';
abstract class SedeRepository { Future<List<Sede>> getAll(); Future<Sede> create(SedeRequestModel request); Future<Sede> update(int id, {required SedeRequestModel request}); Future<void> delete(int id); }
