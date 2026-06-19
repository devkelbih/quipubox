import '../entities/fruta.dart';
import '../repositories/fruta_repository.dart';

class GetFrutasUseCase {
  final FrutaRepository repository;

  GetFrutasUseCase(this.repository);

  Future<List<Fruta>> call() => repository.getAll();
}
