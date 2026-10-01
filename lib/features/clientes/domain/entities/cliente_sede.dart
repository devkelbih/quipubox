import 'package:quipubox/features/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';

import '../../../sedes/domain/entities/sede.dart';

class ClienteSede {
  final int? id;

  final int? idEmpresa;
  final int? idCliente;

  /// FK utilizada para crear/actualizar la relación.
  final int idSede;

  /// Relación opcional cargada desde el backend.
  final Sede? sede;

  final TipoRelacionClienteSede tipoRelacion;

  final String? observaciones;

  final bool estado;

  final DateTime? createdAt;

  const ClienteSede({
    this.id,
    this.idEmpresa,
    this.idCliente,
    required this.idSede,
    this.sede,
    required this.tipoRelacion,
    this.observaciones,
    this.estado = true,
    this.createdAt,
  });

  ClienteSede copyWith({
    int? id,
    int? idEmpresa,
    int? idCliente,
    int? idSede,
    Sede? sede,
    TipoRelacionClienteSede? tipoRelacion,
    String? observaciones,
    bool? estado,
    DateTime? createdAt,
  }) {
    return ClienteSede(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idCliente: idCliente ?? this.idCliente,
      idSede: idSede ?? this.idSede,
      sede: sede ?? this.sede,
      tipoRelacion: tipoRelacion ?? this.tipoRelacion,
      observaciones: observaciones ?? this.observaciones,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}