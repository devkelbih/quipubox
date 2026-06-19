import '../entities/fruta.dart';
import '../repositories/fruta_repository.dart';

class UpdateFrutaUseCase {
  final FrutaRepository repository;

  UpdateFrutaUseCase(this.repository);

  Future<Fruta> call(Fruta fruta) {
    return repository.update(fruta);
  }
}
