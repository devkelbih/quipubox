import '../entities/tipos_jaba.dart';
import '../repositories/tipos_jaba_repository.dart';

class GetTiposJabaUseCase {
  final TipoJabaRepository repository;
  GetTiposJabaUseCase(this.repository);
  Future<List<TipoJaba>> call() => repository.getAll();
}
