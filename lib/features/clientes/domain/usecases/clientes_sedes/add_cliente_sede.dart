import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente_sede.dart';
import 'package:quipubox/features/clientes/domain/repositories/clientes_repository.dart';

class AddClienteSedeUseCase {
  final ClienteRepository repository;

  AddClienteSedeUseCase({
    required this.repository,
  });

  Future<ClienteSede> call(ClienteSede clienteSede) {
    if (clienteSede.idSede <= 0) {
      throw const AppException('No se encontró la sede.');
    }

    return repository.addClienteSede(clienteSede);
  }
}