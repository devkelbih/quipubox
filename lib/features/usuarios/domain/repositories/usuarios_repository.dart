import '../entities/usuario.dart';

abstract class UsuarioRepository {
  Future<List<Usuario>> getAll();
  Future<Usuario> create(Usuario usuario);

  Future<Usuario> update(Usuario usuario);

  Future<bool> changeStatus({required int id, required bool estado});
  Future<void> addRole({required int usuarioId, required int roleId});

  Future<void> removeRole({required int usuarioId, required int roleId});
}
