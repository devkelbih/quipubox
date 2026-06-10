import '../../data/models/usuario_request_model.dart';
import '../entities/usuario.dart';
abstract class UsuarioRepository { Future<List<Usuario>> getAll(); Future<Usuario> create(UsuarioRequestModel request); Future<Usuario> update(int id, {required UsuarioRequestModel request}); Future<void> delete(int id); }
