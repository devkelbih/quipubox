import '../entities/sede.dart';
import '../repositories/sedes_repository.dart';

class ChangeSedeStatusUseCase {
  final SedeRepository repository;

  ChangeSedeStatusUseCase(this.repository);

  Future<Sede> call({required int id, required bool estado}) {
    return repository.changeStatus(id: id, estado: estado);
  }
}
