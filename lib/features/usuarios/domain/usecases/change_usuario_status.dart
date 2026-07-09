import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/usuarios/domain/repositories/usuarios_repository.dart';

class ChangeUsuarioStatusUseCase {
  final UsuarioRepository repository;

  ChangeUsuarioStatusUseCase(this.repository);

  Future<bool> call({required int id, required bool estado}) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID del usuario.');
    }

    return repository.changeStatus(id: id, estado: estado);
  }
}
