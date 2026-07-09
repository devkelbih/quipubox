import 'package:quipubox/core/exceptions/app_exception.dart';

import '../entities/usuario.dart';
import '../repositories/usuarios_repository.dart';

class UpdateUsuarioUseCase {
  final UsuarioRepository repository;

  UpdateUsuarioUseCase(this.repository);

  Future<Usuario> call(Usuario usuario) {
    if (usuario.id <= 0) {
      throw const AppException(
        'No se encontró el ID del usuario.',
      );
    }

    if (usuario.sede.id == null) {
      throw const AppException(
        'No se encontró el ID de la sede.',
      );
    }

    if (usuario.roles.isEmpty) {
      throw const AppException(
        'Debes asignar al menos un rol al usuario.',
      );
    }

    return repository.update(usuario);
  }
}