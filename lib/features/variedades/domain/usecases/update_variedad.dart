import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/variedad.dart';
import '../repositories/variedad_repository.dart';

class UpdateVariedadUseCase {
  final VariedadRepository repository;

  UpdateVariedadUseCase(this.repository);

  Future<Variedad> call(Variedad variedad) {
    if (variedad.id == null) {
      throw const AppException('El ID de la variedad no puede ser nulo.');
    }
    return repository.update(variedad);
  }
}
