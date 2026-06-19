import '../entities/variedad.dart';
import '../repositories/variedad_repository.dart';

class GetVariedadesByFrutaUseCase {
  final VariedadRepository repository;

  GetVariedadesByFrutaUseCase(this.repository);

  Future<List<Variedad>> call(int frutaId) => repository.getByFruta(frutaId);
}
