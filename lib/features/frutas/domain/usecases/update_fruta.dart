import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/fruta.dart';
import '../repositories/fruta_repository.dart';

class UpdateFrutaUseCase {
  final FrutaRepository repository;

  UpdateFrutaUseCase(this.repository);

  Future<Fruta> call(Fruta fruta) {
    if (fruta.id == null) {
      throw const AppException('No se encontró el ID de la fruta.');
    }
    return repository.update(fruta);
  }
}
