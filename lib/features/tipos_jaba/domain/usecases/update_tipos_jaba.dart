import '../entities/tipos_jaba.dart';
import '../repositories/tipos_jaba_repository.dart';

class UpdateTipoJabaUseCase {
  final TipoJabaRepository repository;
  UpdateTipoJabaUseCase(this.repository);
  Future<TipoJaba> call(TipoJaba tipoJaba) {
    return repository.update(tipoJaba);
  }
}
