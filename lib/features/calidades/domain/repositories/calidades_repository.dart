import '../../data/models/calidad_request_model.dart';
import '../entities/calidad.dart';
abstract class CalidadRepository { Future<List<Calidad>> getAll(); Future<Calidad> create(CalidadRequestModel request); Future<Calidad> update(int id, {required CalidadRequestModel request}); Future<void> delete(int id); }
