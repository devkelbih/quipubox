import '../../data/models/usuario_request_model.dart';
import '../entities/usuario.dart';
import '../repositories/usuarios_repository.dart';
class UpdateUsuarioUseCase { final UsuarioRepository repository; UpdateUsuarioUseCase(this.repository); Future<Usuario> call(int id, {required UsuarioRequestModel request}) => repository.update(id, request: request); }
