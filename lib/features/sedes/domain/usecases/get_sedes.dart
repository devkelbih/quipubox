import '../entities/sede.dart';
import '../repositories/sedes_repository.dart';

class GetSedesUseCase {
  final SedeRepository repository;
  GetSedesUseCase(this.repository);
  Future<List<Sede>> call() => repository.getAll();
}
