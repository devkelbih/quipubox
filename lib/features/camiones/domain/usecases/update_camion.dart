import '../entities/camion.dart';
import '../repositories/camiones_repository.dart';

class UpdateCamionUseCase {
  final CamionRepository repository;
  UpdateCamionUseCase(this.repository);
  Future<Camion> call(Camion camion) {
    return repository.update(camion);
  }
}
