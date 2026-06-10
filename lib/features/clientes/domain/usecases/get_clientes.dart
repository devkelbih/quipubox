import '../entities/cliente.dart';
import '../repositories/clientes_repository.dart';
class GetClientesUseCase { final ClienteRepository repository; GetClientesUseCase(this.repository); Future<List<Cliente>> call() => repository.getAll(); }
