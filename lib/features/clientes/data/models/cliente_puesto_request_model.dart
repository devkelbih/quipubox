import 'package:quipubox/features/clientes/domain/entities/cliente_puesto.dart';

class ClientePuestoRequestModel {
  final int idPuesto;
  final String? seccion;

  const ClientePuestoRequestModel({required this.idPuesto, this.seccion});

  factory ClientePuestoRequestModel.fromEntity(ClientePuesto clientePuesto) {
    return ClientePuestoRequestModel(
      idPuesto: clientePuesto.idPuesto,
      seccion: clientePuesto.seccion?.value,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    'id_puesto': idPuesto,
    if (seccion != null && seccion!.trim().isNotEmpty)
      'seccion': seccion!.trim(),
  };
}
