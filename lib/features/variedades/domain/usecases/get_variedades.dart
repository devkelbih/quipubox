import '../entities/variedad.dart';
import '../repositories/variedad_repository.dart';

class GetVariedadesUseCase {
  final VariedadRepository repository;

  GetVariedadesUseCase(this.repository);

  Future<List<Variedad>> call() => repository.getAll();
}
