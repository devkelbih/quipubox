import '../entities/tipos_jaba.dart';
import '../repositories/tipos_jaba_repository.dart';

class GetTiposJabaUseCase {
  final TipoJabaRepository repository;

  GetTiposJabaUseCase({required this.repository});
  Future<List<TiposJaba>> call() => repository.getAll();
}
