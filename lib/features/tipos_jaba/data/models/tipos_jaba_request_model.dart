
import 'package:quipubox/core/common/string_extensions.dart';

import '../../domain/entities/tipos_jaba.dart';

class TipoJabaRequestModel {
  final int? idEmpresa;
  final String nombre;
  final String tipoMaterial;
  final String? descripcion;

  const TipoJabaRequestModel({
    this.idEmpresa,
    required this.nombre,
    required this.tipoMaterial,
    this.descripcion,
  });

  factory TipoJabaRequestModel.fromEntity(TiposJaba item) {
    return TipoJabaRequestModel(
      idEmpresa: item.idEmpresa,
      nombre: item.nombre,
      tipoMaterial: item.tipoMaterial.value,
      descripcion: item.descripcion,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    if (idEmpresa != null) 'id_empresa': idEmpresa,
    if (nombre.hasText) 'nombre': nombre.value,
    if (tipoMaterial.hasText) 'tipo_material': tipoMaterial.value,
    if (descripcion.hasText) 'descripcion': descripcion.value,
  };

  Map<String, dynamic> toUpdateJson() => {
    if (nombre.hasText) 'nombre': nombre.value,
    if (tipoMaterial.hasText) 'tipo_material': tipoMaterial.value,
    if (descripcion.hasText) 'descripcion': descripcion.value,
  };
}
