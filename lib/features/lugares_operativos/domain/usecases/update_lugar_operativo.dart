import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/lugar_operativo.dart';
import '../repositories/lugares_operativos_repository.dart';

class UpdateLugarOperativoUseCase {
  final LugarOperativoRepository repository;

  UpdateLugarOperativoUseCase(this.repository);

  Future<LugarOperativo> call(LugarOperativo lugarOperativo) {
    if (lugarOperativo.id == null) {
      throw const AppException(
        'No se encontró el ID del lugar operativo.',
      );
    }

    return repository.update(lugarOperativo);
  }
}