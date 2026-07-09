import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/tipos_jaba.dart';
import '../repositories/tipos_jaba_repository.dart';

class UpdateTipoJabaUseCase {
  final TipoJabaRepository repository;
  UpdateTipoJabaUseCase(this.repository);
  Future<TipoJaba> call(TipoJaba tipoJaba) {
    if (tipoJaba.id == null) {
      throw const AppException('No se encontró el ID del tipo de jaba.');
    }
    return repository.update(tipoJaba);
  }
}
