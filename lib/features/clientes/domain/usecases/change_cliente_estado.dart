import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/clientes/domain/repositories/clientes_repository.dart';

class ChangeClienteEstadoUseCase {
  final ClienteRepository repository;

  ChangeClienteEstadoUseCase({
    required this.repository,
  });

  Future<bool> call({
    required int id,
    required bool estado,
  }) {
    if (id <= 0) {
      throw const AppException('No se encontró el ID del cliente.');
    }

    return repository.changeStatus(
      id: id,
      estado: estado,
    );
  }
}