import 'package:quipubox/features/clientes/domain/entities/cliente_puesto.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente_sede.dart';

import '../entities/cliente.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getAll();
  Future<Cliente> create(Cliente cliente);
  Future<Cliente> update(Cliente cliente);
  Future<bool> changeStatus({required int id, required bool estado});

  Future<void> assignSede({
    required int idCliente,
    required int idSede,
    required String tipoRelacion,
  });
  Future<void> assignPuesto({
    required int idCliente,
    required int idPuesto,
    String? seccion,
  });
  Future<void> deletePuesto({required int idCliente, required int idPuesto});

  Future<ClienteSede> addClienteSede(ClienteSede clienteSede);

  Future<ClienteSede> updateClienteSedeRelation(ClienteSede clienteSede);

  Future<ClientePuesto> addClientePuesto(ClientePuesto clientePuesto);
}
