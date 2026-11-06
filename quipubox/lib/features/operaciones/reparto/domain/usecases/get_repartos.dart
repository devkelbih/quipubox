import '../entities/reparto.dart';
import '../repositories/reparto_repository.dart';

class GetRepartosUseCase {
  final RepartoRepository repository;
  const GetRepartosUseCase(this.repository);
  Future<List<Reparto>> call() => repository.getAll();
}
