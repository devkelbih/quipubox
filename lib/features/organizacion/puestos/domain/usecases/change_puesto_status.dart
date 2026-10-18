import 'package:quipubox/core/exceptions/app_exception.dart';

import '../repositories/puestos_repository.dart';

class ChangePuestoStatusUseCase {
  final PuestoRepository repository;
  ChangePuestoStatusUseCase({required this.repository});
  Future<bool> call({required int id, required bool estado}) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID de la sede.');
    }
    return repository.changeStatus(id: id, estado: estado);
  }
}
