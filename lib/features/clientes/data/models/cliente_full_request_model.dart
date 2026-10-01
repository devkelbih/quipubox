import 'package:quipubox/features/clientes/domain/entities/cliente.dart';

import 'cliente_puesto_request_model.dart';
import 'cliente_request_model.dart';
import 'cliente_sede_request_model.dart';

class ClienteFullRequestModel {
  final ClienteRequestModel cliente;
  final List<ClienteSedeRequestModel> sedes;
  final List<ClientePuestoRequestModel> puestos;

  const ClienteFullRequestModel({
    required this.cliente,
    required this.sedes,
    required this.puestos,
  });

  factory ClienteFullRequestModel.fromEntity(Cliente cliente) {
    return ClienteFullRequestModel(
      cliente: ClienteRequestModel.fromEntity(cliente),
      sedes: cliente.sedes.map(ClienteSedeRequestModel.fromEntity).toList(),
      puestos: cliente.puestos
          .map(ClientePuestoRequestModel.fromEntity)
          .toList(),
    );
  }

  Map<String, dynamic> toCreateJson() => {
    ...cliente.toCreateJson(),
    'sedes': sedes.map((sede) => sede.toCreateJson()).toList(),
    'puestos': puestos.map((puesto) => puesto.toCreateJson()).toList(),
  };

  Map<String, dynamic> toUpdateJson() => {
    ...cliente.toUpdateJson(),
    'sedes': sedes.map((sede) => sede.toCreateJson()).toList(),
    'puestos': puestos.map((puesto) => puesto.toCreateJson()).toList(),
  };
}
