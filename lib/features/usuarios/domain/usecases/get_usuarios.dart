import '../entities/usuario.dart';
import '../repositories/usuarios_repository.dart';

class GetUsuariosUseCase {
  final UsuarioRepository repository;
  GetUsuariosUseCase(this.repository);
  Future<List<Usuario>> call() => repository.getAll();
}
