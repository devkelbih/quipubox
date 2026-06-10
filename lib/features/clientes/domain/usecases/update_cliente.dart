import '../../data/models/cliente_request_model.dart';
import '../entities/cliente.dart';
import '../repositories/clientes_repository.dart';
class UpdateClienteUseCase { final ClienteRepository repository; UpdateClienteUseCase(this.repository); Future<Cliente> call(int id, {required ClienteRequestModel request}) => repository.update(id, request: request); }
