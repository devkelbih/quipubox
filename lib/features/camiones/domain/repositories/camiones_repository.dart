import '../../data/models/camion_request_model.dart';
import '../entities/camion.dart';
abstract class CamionRepository { Future<List<Camion>> getAll(); Future<Camion> create(CamionRequestModel request); Future<Camion> update(int id, {required CamionRequestModel request}); Future<void> delete(int id); }
