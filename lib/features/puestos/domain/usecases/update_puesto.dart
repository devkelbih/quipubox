import 'package:quipubox/features/puestos/domain/repositories/puestos_repository.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../entities/puesto.dart';

class UpdatePuestoUseCase {
  final PuestoRepository repository;

  UpdatePuestoUseCase({required this.repository});

  Future<Puesto> call(Puesto puesto) {
    if (puesto.id == null) {
      throw const AppException('El puesto no tiene un identificador válido.');
    }

    return repository.update(puesto);
  }
}
