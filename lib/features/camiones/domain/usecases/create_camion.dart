import '../../data/models/camion_request_model.dart';
import '../entities/camion.dart';
import '../repositories/camiones_repository.dart';
class CreateCamionUseCase { final CamionRepository repository; CreateCamionUseCase(this.repository); Future<Camion> call(CamionRequestModel request) => repository.create(request); }
