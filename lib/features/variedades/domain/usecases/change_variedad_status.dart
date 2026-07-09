import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/variedades/domain/repositories/variedad_repository.dart';

class ChangeVariedadStatusUseCase {
  final VariedadRepository repository;

  ChangeVariedadStatusUseCase(this.repository);

  Future<bool> call({required int id, required bool estado}) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID de la variedad.');
    }
    return repository.changeStatus(id: id, estado: estado);
  }
}
