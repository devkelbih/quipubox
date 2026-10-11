import 'package:quipubox/core/common/string_extensions.dart';

import '../../domain/entities/fruta.dart';

class FrutaRequestModel {
  final int? idEmpresa;
  final String nombre;
  final String? descripcion;

  const FrutaRequestModel({
    this.idEmpresa,
    required this.nombre,
    this.descripcion,
  });

  factory FrutaRequestModel.fromEntity(Fruta item) {
    return FrutaRequestModel(
      idEmpresa: item.idEmpresa,
      nombre: item.nombre,
      descripcion: item.descripcion,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        if (idEmpresa != null) 'id_empresa': idEmpresa,
        if (nombre.hasText) 'nombre': nombre.value,
        if (descripcion.hasText) 'descripcion': descripcion.value,
      };

  Map<String, dynamic> toUpdateJson() => {
        if (nombre.hasText) 'nombre': nombre.value,
        if (descripcion.hasText) 'descripcion': descripcion.value,
      };
}
