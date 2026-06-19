import '../entities/calidad.dart';
import '../repositories/calidad_repository.dart';

class UpdateCalidadUseCase {
  final CalidadRepository repository;

  UpdateCalidadUseCase(this.repository);

  Future<Calidad> call(Calidad calidad) {
    return repository.update(calidad);
  }
}
