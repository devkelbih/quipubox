import 'package:quipubox/features/lugares_operativos/domain/enums/lugar_operativo_tipos.dart';

import 'package:quipubox/core/common/string_extensions.dart';

import '../../domain/entities/lugar_operativo.dart';

class LugarOperativoRequestModel {
  final int? idEmpresa;
  final int idSede;
  final String nombre;
  final LugarOperativoTipos tipoLugar;
  final String? direccionReferencia;
  final String? observaciones;

  const LugarOperativoRequestModel({
    this.idEmpresa,
    required this.idSede,
    required this.nombre,
    required this.tipoLugar,
    this.direccionReferencia,
    this.observaciones,
  });

  factory LugarOperativoRequestModel.fromEntity(LugarOperativo lugarOperativo) {
    return LugarOperativoRequestModel(
      idEmpresa: lugarOperativo.idEmpresa,
      idSede: lugarOperativo.idSede,
      nombre: lugarOperativo.nombre,
      tipoLugar: lugarOperativo.tipoLugar,
      direccionReferencia: lugarOperativo.direccionReferencia,
      observaciones: lugarOperativo.observaciones,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    if (idEmpresa != null) 'id_empresa': idEmpresa,
    'id_sede': idSede,
    if (nombre.hasText) 'nombre': nombre.value,
    'tipo_lugar': tipoLugar.value,
    if (direccionReferencia.hasText)
      'direccion_referencia': direccionReferencia.value,
    if (observaciones.hasText) 'observaciones': observaciones.value,
  };

  Map<String, dynamic> toUpdateJson() => {
    'id_sede': idSede,
    if (nombre.hasText) 'nombre': nombre.value,
    'tipo_lugar': tipoLugar.value,
    if (direccionReferencia.hasText)
      'direccion_referencia': direccionReferencia.value,
    if (observaciones.hasText) 'observaciones': observaciones.value,
  };
}
