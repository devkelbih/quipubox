import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/camion.dart';
import '../repositories/camiones_repository.dart';

class UpdateCamionUseCase {
  final CamionRepository repository;
  UpdateCamionUseCase(this.repository);
  Future<Camion> call(Camion camion) {
    if (camion.id == null) {
      throw const AppException('No se encontró el ID del camión.');
    }

    return repository.update(camion);
  }
}
