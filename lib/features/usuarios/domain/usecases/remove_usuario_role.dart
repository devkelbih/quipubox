import 'package:quipubox/core/exceptions/app_exception.dart';

import '../repositories/usuarios_repository.dart';

class RemoveUsuarioRoleUseCase {
  final UsuarioRepository repository;

  RemoveUsuarioRoleUseCase(this.repository);

  Future<void> call({
    required int usuarioId,
    required int roleId,
  }) {
    if (usuarioId <= 0) {
      throw const AppException(
        'No se encontró el ID del usuario.',
      );
    }

    if (roleId <= 0) {
      throw const AppException(
        'No se encontró el ID del rol.',
      );
    }

    return repository.removeRole(
      usuarioId: usuarioId,
      roleId: roleId,
    );
  }
}