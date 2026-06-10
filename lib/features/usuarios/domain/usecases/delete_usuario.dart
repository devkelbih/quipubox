import '../repositories/usuarios_repository.dart';
class DeleteUsuarioUseCase { final UsuarioRepository repository; DeleteUsuarioUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
