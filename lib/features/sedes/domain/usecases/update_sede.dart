import '../entities/sede.dart';
import '../repositories/sedes_repository.dart';

class UpdateSedeUseCase {
  final SedeRepository repository;

  UpdateSedeUseCase(this.repository);

  Future<Sede> call(Sede sede) {
    return repository.update(sede);
  }
}