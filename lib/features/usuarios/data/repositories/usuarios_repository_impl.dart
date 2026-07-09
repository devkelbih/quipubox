import 'package:quipubox/features/usuarios/data/datasources/usuarios_remote_data_source.dart';
import 'package:quipubox/features/usuarios/data/models/usuario_request_model.dart';
import 'package:quipubox/features/usuarios/domain/entities/usuario.dart';
import 'package:quipubox/features/usuarios/domain/repositories/usuarios_repository.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDataSource remoteDataSource;

  UsuarioRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Usuario>> getAll() async {
    final models = await remoteDataSource.getAll();

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Usuario> create(Usuario usuario) async {

    final request = UsuarioRequestModel.fromEntity(usuario);
    final model = await remoteDataSource.create(request);

    return model.toEntity();
  }

  @override
  Future<Usuario> update(Usuario usuario) async {
    final request = UsuarioRequestModel.fromEntity(usuario);
    final model = await remoteDataSource.update(usuario.id, request: request);

    return model.toEntity();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) {

    return remoteDataSource.changeStatus(id: id, estado: estado);
  }
}
