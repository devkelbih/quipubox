
import 'package:quipubox/core/common/string_extensions.dart';

import '../../domain/entities/variedad.dart';

class VariedadRequestModel {
  final int? idEmpresa;
  final int? idFruta;
  final String nombre;
  final String? descripcion;

  const VariedadRequestModel({
    this.idEmpresa,
    this.idFruta,
    required this.nombre,
    this.descripcion,
  });

  factory VariedadRequestModel.fromEntity(Variedad item) {
    return VariedadRequestModel(
      idEmpresa: item.idEmpresa,
      idFruta: item.idFruta,
      nombre: item.nombre,
      descripcion: item.descripcion,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        if (idEmpresa != null) 'id_empresa': idEmpresa,
        if (idFruta != null) 'id_fruta': idFruta,
        if (nombre.hasText) 'nombre': nombre.value,
        if (descripcion.hasText) 'descripcion': descripcion.value,
      };

  Map<String, dynamic> toUpdateJson() => {
        if (idFruta != null) 'id_fruta': idFruta,
        if (nombre.hasText) 'nombre': nombre.value,
        if (descripcion.hasText) 'descripcion': descripcion.value,
      };
}
