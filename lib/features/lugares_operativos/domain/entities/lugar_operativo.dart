import 'package:quipubox/features/sedes/domain/entities/sede.dart';

import '../enums/lugar_operativo_tipos.dart';

class LugarOperativo {
  final int? id;

  final int? idEmpresa;

  /// FK utilizada para crear y actualizar.
  final int idSede;

  /// Relación opcional cargada desde el backend.
  final Sede? sede;

  final bool estado;

  final String nombre;

  final String? direccionReferencia;

  final String? observaciones;

  final LugarOperativoTipos tipoLugar;

  const LugarOperativo({
    this.id,
    this.idEmpresa,
    required this.idSede,
    this.sede,
    this.estado = true,
    required this.nombre,
    this.direccionReferencia,
    this.observaciones,
    required this.tipoLugar,
  });

  LugarOperativo copyWith({
    int? id,
    int? idEmpresa,
    int? idSede,
    Sede? sede,
    bool? estado,
    String? nombre,
    String? direccionReferencia,
    String? observaciones,
    LugarOperativoTipos? tipoLugar,
  }) {
    return LugarOperativo(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idSede: idSede ?? this.idSede,
      sede: sede ?? this.sede,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      direccionReferencia: direccionReferencia ?? this.direccionReferencia,
      observaciones: observaciones ?? this.observaciones,
      tipoLugar: tipoLugar ?? this.tipoLugar,
    );
  }
}
