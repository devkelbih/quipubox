
import 'package:quipubox/features/organizacion/sedes/domain/enums/tipo_sede.dart';

import 'package:quipubox/core/common/string_extensions.dart';

import '../../domain/entities/sede.dart';

class SedeRequestModel {
  final int? idEmpresa;
  final String nombre;
  final TipoSede tipoSede;
  final String? direccion;
  final String? ciudad;
  final String? departamento;

  const SedeRequestModel({
    this.idEmpresa,
    required this.nombre,
    required this.tipoSede,
    this.direccion,
    this.ciudad,
    this.departamento,
  });

  factory SedeRequestModel.fromEntity(Sede sede) {
    return SedeRequestModel(
      idEmpresa: sede.idEmpresa,
      nombre: sede.nombre,
      tipoSede: sede.tipoSede,
      direccion: sede.direccion,
      ciudad: sede.ciudad,
      departamento: sede.departamento,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        if (idEmpresa != null) 'id_empresa': idEmpresa,
        if (nombre.hasText) 'nombre': nombre.value,
        'tipo_sede': tipoSede.value,
        if (direccion.hasText) 'direccion': direccion.value,
        if (ciudad.hasText) 'ciudad': ciudad.value,
        if (departamento.hasText) 'departamento': departamento.value,
      };

  Map<String, dynamic> toUpdateJson() => {
        if (nombre.hasText) 'nombre': nombre.value,
        'tipo_sede': tipoSede.value,
        if (direccion.hasText) 'direccion': direccion.value,
        if (ciudad.hasText) 'ciudad': ciudad.value,
        if (departamento.hasText) 'departamento': departamento.value,
      };
}
