import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente_sede.dart';
import 'package:quipubox/features/clientes/domain/repositories/clientes_repository.dart';

class UpdateClienteSedeRelationUseCase {
  final ClienteRepository repository;

  UpdateClienteSedeRelationUseCase({
    required this.repository,
  });

  Future<ClienteSede> call(ClienteSede clienteSede) {
    if (clienteSede.id == null || clienteSede.id! <= 0) {
      throw const AppException(
        'No se encontró el ID de la relación cliente-sede.',
      );
    }

    return repository.updateClienteSedeRelation(clienteSede);
  }
}