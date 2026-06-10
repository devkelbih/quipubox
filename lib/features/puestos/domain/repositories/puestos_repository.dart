import '../../data/models/puesto_request_model.dart';
import '../entities/puesto.dart';
abstract class PuestoRepository { Future<List<Puesto>> getAll(); Future<Puesto> create(PuestoRequestModel request); Future<Puesto> update(int id, {required PuestoRequestModel request}); Future<void> delete(int id); }
