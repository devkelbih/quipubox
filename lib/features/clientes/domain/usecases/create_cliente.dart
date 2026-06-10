import '../../data/models/cliente_request_model.dart';
import '../entities/cliente.dart';
import '../repositories/clientes_repository.dart';
class CreateClienteUseCase { final ClienteRepository repository; CreateClienteUseCase(this.repository); Future<Cliente> call(ClienteRequestModel request) => repository.create(request); }
