import '../repositories/clientes_repository.dart';

class DeleteClienteUseCase {
  final ClienteRepository repository;
  DeleteClienteUseCase({required this.repository});
  Future<void> call(int id) => repository.delete(id);
}
