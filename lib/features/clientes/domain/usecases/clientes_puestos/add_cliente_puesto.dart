import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente_puesto.dart';
import 'package:quipubox/features/clientes/domain/repositories/clientes_repository.dart';

class AddClientePuestoUseCase {
  final ClienteRepository repository;

  AddClientePuestoUseCase({
    required this.repository,
  });

  Future<ClientePuesto> call(ClientePuesto clientePuesto) {
    if (clientePuesto.idPuesto <= 0) {
      throw const AppException('No se encontró el puesto.');
    }

    return repository.addClientePuesto(clientePuesto);
  }
}