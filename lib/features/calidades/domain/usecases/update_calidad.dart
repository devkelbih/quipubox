import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/calidad.dart';
import '../repositories/calidad_repository.dart';

class UpdateCalidadUseCase {
  final CalidadRepository repository;

  UpdateCalidadUseCase(this.repository);

  Future<Calidad> call(Calidad calidad) {
    if (calidad.id == null) {
      throw const AppException('No se encontró el ID de la calidad.');
    }
    return repository.update(calidad);
  }
}
