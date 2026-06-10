import '../../data/models/usuario_request_model.dart';
import '../entities/usuario.dart';
import '../repositories/usuarios_repository.dart';
class CreateUsuarioUseCase { final UsuarioRepository repository; CreateUsuarioUseCase(this.repository); Future<Usuario> call(UsuarioRequestModel request) => repository.create(request); }
