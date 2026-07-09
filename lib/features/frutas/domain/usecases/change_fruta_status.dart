import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/frutas/domain/repositories/fruta_repository.dart';

class ChangeFrutaStatusUseCase {
  final FrutaRepository repository;

  ChangeFrutaStatusUseCase(this.repository);

  Future<bool> call({required int id, required bool estado}) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID del camión.');
    }
    return repository.changeStatus(id: id, estado: estado);
  }
}
