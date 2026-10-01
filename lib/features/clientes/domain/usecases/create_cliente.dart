import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/clientes/domain/repositories/clientes_repository.dart';

class CreateClienteUseCase {
  final ClienteRepository repository;
  final CurrentSession currentSession;

  CreateClienteUseCase({
    required this.repository,
    required this.currentSession,
  });

  Future<Cliente> call(Cliente cliente) {
    final idEmpresa = currentSession.currentCompanyId;

    if (idEmpresa == null) {
      throw const AppException('No se encontró la empresa del usuario.');
    }

    if (cliente.sedes.isEmpty) {
      throw const AppException('Debes asignar al menos una sede al cliente.');
    }

    return repository.create(cliente.copyWith(idEmpresa: idEmpresa));
  }
}
