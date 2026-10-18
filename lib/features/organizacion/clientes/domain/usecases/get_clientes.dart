import '../entities/cliente.dart';
import '../repositories/clientes_repository.dart';

class GetClientesUseCase {
  final ClienteRepository repository;

  GetClientesUseCase({required this.repository});
  Future<List<Cliente>> call() => repository.getAll();
}
