import 'package:quipubox/features/clientes/domain/enums/secciones_cliente_puesto.dart';

import '../../../puestos/domain/entities/puesto.dart';

class ClientePuesto {
  final int? id;

  final int? idEmpresa;
  final int? idCliente;

  /// FK utilizada para crear/actualizar la relación.
  final int idPuesto;

  /// Relación opcional cargada desde el backend.
  final Puesto? puesto;

  final DateTime? fechaInicio;
  final DateTime? fechaFin;

  final bool estado;

  final String? observaciones;

  final SeccionClientePuesto? seccion;

  final DateTime? createdAt;

  const ClientePuesto({
    this.id,
    this.idEmpresa,
    this.idCliente,
    required this.idPuesto,
    this.puesto,
    this.fechaInicio,
    this.fechaFin,
    this.estado = true,
    this.observaciones,
    this.seccion,
    this.createdAt,
  });

  ClientePuesto copyWith({
    int? id,
    int? idEmpresa,
    int? idCliente,
    int? idPuesto,
    Puesto? puesto,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? estado,
    String? observaciones,
    SeccionClientePuesto? seccion,
    DateTime? createdAt,
  }) {
    return ClientePuesto(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idCliente: idCliente ?? this.idCliente,
      idPuesto: idPuesto ?? this.idPuesto,
      puesto: puesto ?? this.puesto,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
      seccion: seccion ?? this.seccion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}