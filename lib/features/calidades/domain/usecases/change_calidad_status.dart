import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/calidades/domain/repositories/calidad_repository.dart';

class ChangeCalidadStatusUseCase {
  final CalidadRepository repository;

  ChangeCalidadStatusUseCase(this.repository);

  Future<bool> call({required int id, required bool estado}) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID de la calidad.');
    }
    return repository.changeStatus(id: id, estado: estado);
  }
}
