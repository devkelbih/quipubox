import '../entities/variedad.dart';
import '../repositories/variedad_repository.dart';

class UpdateVariedadUseCase {
  final VariedadRepository repository;

  UpdateVariedadUseCase(this.repository);

  Future<Variedad> call(Variedad variedad) {
    return repository.update(variedad);
  }
}
