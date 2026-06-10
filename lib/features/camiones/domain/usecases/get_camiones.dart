import '../entities/camion.dart';
import '../repositories/camiones_repository.dart';
class GetCamionesUseCase { final CamionRepository repository; GetCamionesUseCase(this.repository); Future<List<Camion>> call() => repository.getAll(); }
