import 'package:quipubox/features/frutas/domain/entities/fruta.dart';
import 'package:quipubox/features/frutas/domain/repositories/fruta_repository.dart';

class ChangeFrutaStatusUseCase {
  final FrutaRepository repository;

  ChangeFrutaStatusUseCase(this.repository);

  Future<Fruta> call({required int id, required bool estado}) {
    return repository.changeStatus(id: id, estado: estado);
  }
}
