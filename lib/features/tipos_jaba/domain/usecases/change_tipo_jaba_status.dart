import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';

class ChangeTipoJabaStatusUseCase {
  final TipoJabaRepository repository;

  ChangeTipoJabaStatusUseCase(this.repository);

  Future<bool> call({required int id, required bool estado}) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID del tipo de jaba.');
    }
    return repository.changeStatus(id: id, estado: estado);
  }
}
