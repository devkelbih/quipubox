import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/usuarios/domain/entities/usuario.dart';
import 'package:quipubox/features/usuarios/domain/repositories/usuarios_repository.dart';

class CreateUsuarioUseCase {
  final UsuarioRepository repository;
  final CurrentSession currentSession;

  CreateUsuarioUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Usuario> call(Usuario usuario) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    if (usuario.roles.isEmpty) {
      throw const AppException('Debes asignar al menos un rol al usuario.');
    }

    return repository.create(usuario.copyWith(idEmpresa: idEmpresa));
  }
}
