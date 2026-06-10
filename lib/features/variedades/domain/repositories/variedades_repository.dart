import '../../data/models/variedad_request_model.dart';
import '../entities/variedad.dart';
abstract class VariedadRepository { Future<List<Variedad>> getAll(); Future<Variedad> create(VariedadRequestModel request); Future<Variedad> update(int id, {required VariedadRequestModel request}); Future<void> delete(int id); }
