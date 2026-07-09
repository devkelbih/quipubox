
import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/camiones/domain/repositories/camiones_repository.dart';

class ChangeCamionStatusUseCase {
  final CamionRepository repository;

  ChangeCamionStatusUseCase(this.repository);

  Future<bool> call({required int id, required bool estado}) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID del camión.');
    }
    return repository.changeStatus(id: id, estado: estado);
  }
}
