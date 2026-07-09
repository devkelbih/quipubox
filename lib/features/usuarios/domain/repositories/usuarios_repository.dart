import '../entities/usuario.dart';

abstract class UsuarioRepository {
  Future<List<Usuario>> getAll();
  Future<Usuario> create(Usuario usuario);

  Future<Usuario> update(Usuario usuario);

  Future<bool> changeStatus({required int id, required bool estado});
}
