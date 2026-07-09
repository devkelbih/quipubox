import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/sede.dart';
import '../repositories/sedes_repository.dart';

class UpdateSedeUseCase {
  final SedeRepository repository;

  UpdateSedeUseCase(this.repository);

  Future<Sede> call(Sede sede) {
    if (sede.id == null) {
      throw const AppException('No se encontró el ID de la sede.');
    }
    return repository.update(sede);
  }
}
