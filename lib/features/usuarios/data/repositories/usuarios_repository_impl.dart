import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuarios_repository.dart';
import '../datasources/usuarios_remote_data_source.dart';
import '../models/usuario_request_model.dart';
class UsuarioRepositoryImpl implements UsuarioRepository { final UsuarioRemoteDataSource remoteDataSource; UsuarioRepositoryImpl(this.remoteDataSource); @override Future<List<Usuario>> getAll() => remoteDataSource.getAll(); @override Future<Usuario> create(UsuarioRequestModel request) => remoteDataSource.create(request); @override Future<Usuario> update(int id, {required UsuarioRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
