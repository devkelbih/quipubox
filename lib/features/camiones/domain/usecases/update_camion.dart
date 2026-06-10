import '../../data/models/camion_request_model.dart';
import '../entities/camion.dart';
import '../repositories/camiones_repository.dart';
class UpdateCamionUseCase { final CamionRepository repository; UpdateCamionUseCase(this.repository); Future<Camion> call(int id, {required CamionRequestModel request}) => repository.update(id, request: request); }
