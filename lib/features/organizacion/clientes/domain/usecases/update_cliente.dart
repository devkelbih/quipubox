import 'package:quipubox/core/exceptions/app_exception.dart';
import '../entities/cliente.dart';
import '../repositories/clientes_repository.dart';

class UpdateClienteUseCase {
  final ClienteRepository repository;
  UpdateClienteUseCase({required this.repository});
  Future<Cliente> call(Cliente cliente) {
    if (cliente.id == null || cliente.id! <= 0) {
      throw const AppException('No se encontró el ID del cliente.');
    }

    if (cliente.sedes.isEmpty) {
      throw const AppException('Debes asignar al menos una sede al cliente.');
    }

    return repository.update(cliente);
  }
}
