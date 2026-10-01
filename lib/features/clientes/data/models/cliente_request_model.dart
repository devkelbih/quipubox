import 'package:quipubox/features/clientes/domain/entities/cliente.dart';

class ClienteRequestModel {
  final int? idEmpresa;

  final String nombres;
  final String? apellidos;
  final String? apodo;
  final String? telefono;
  final String? observaciones;
  final bool estado;

  const ClienteRequestModel({
    this.idEmpresa,
    required this.nombres,
    this.apellidos,
    this.apodo,
    this.telefono,
    this.observaciones,
    required this.estado,
  });

  factory ClienteRequestModel.fromEntity(Cliente cliente) {
    return ClienteRequestModel(
      idEmpresa: cliente.idEmpresa,
      nombres: cliente.nombres,
      apellidos: cliente.apellidos,
      apodo: cliente.apodo,
      telefono: cliente.telefono,
      observaciones: cliente.observaciones,
      estado: cliente.estado,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    if (idEmpresa != null) 'id_empresa': idEmpresa,
    'nombres': nombres.trim(),
    if (apellidos != null && apellidos!.trim().isNotEmpty)
      'apellidos': apellidos!.trim(),
    if (apodo != null && apodo!.trim().isNotEmpty)
      'apodo': apodo!.trim(),
    if (telefono != null && telefono!.trim().isNotEmpty)
      'telefono': telefono!.trim(),
    if (observaciones != null && observaciones!.trim().isNotEmpty)
      'observaciones': observaciones!.trim(),
    'estado': estado,
  };

  Map<String, dynamic> toUpdateJson() => {
    'nombres': nombres.trim(),
    if (apellidos != null && apellidos!.trim().isNotEmpty)
      'apellidos': apellidos!.trim(),
    if (apodo != null && apodo!.trim().isNotEmpty)
      'apodo': apodo!.trim(),
    if (telefono != null && telefono!.trim().isNotEmpty)
      'telefono': telefono!.trim(),
    if (observaciones != null && observaciones!.trim().isNotEmpty)
      'observaciones': observaciones!.trim(),
    'estado': estado,
  };
}