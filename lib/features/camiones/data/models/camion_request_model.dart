
import 'package:quipubox/core/common/string_extensions.dart';

import '../../domain/entities/camion.dart';

class CamionRequestModel {
  final int? idEmpresa;
  final String placa;
  final String? descripcion;
  final String? observaciones;

  const CamionRequestModel({
    this.idEmpresa,
    required this.placa,
    this.descripcion,
    this.observaciones,
  });

  factory CamionRequestModel.fromEntity(Camion camion) {
    return CamionRequestModel(
      idEmpresa: camion.idEmpresa,
      placa: camion.placa,
      descripcion: camion.descripcion,
      observaciones: camion.observaciones,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      if (idEmpresa != null) 'id_empresa': idEmpresa,
      'placa': placa.value,
      if (descripcion.hasText) 'descripcion': descripcion.value,
      if (observaciones.hasText) 'observaciones': observaciones.value,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'placa': placa.value,
      if (descripcion.hasText) 'descripcion': descripcion.value,
      if (observaciones.hasText) 'observaciones': observaciones.value,
    };
  }
}
