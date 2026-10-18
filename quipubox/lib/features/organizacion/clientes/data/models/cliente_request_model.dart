import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';
import 'package:quipubox/core/common/string_extensions.dart';

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
    'nombres': nombres.value,
    if (apellidos.hasText) 'apellidos': apellidos.value,
    if (apodo.hasText) 'apodo': apodo.value,
    if (telefono.hasText) 'telefono': telefono.value,
    if (observaciones.hasText) 'observaciones': observaciones.value,
    'estado': estado,
  };

  Map<String, dynamic> toUpdateJson() => {
    'nombres': nombres.value,
    if (apellidos.hasText) 'apellidos': apellidos.value,
    if (apodo.hasText) 'apodo': apodo.value,
    if (telefono.hasText) 'telefono': telefono.value,
    if (observaciones.hasText) 'observaciones': observaciones.value,
    'estado': estado,
  };
}
