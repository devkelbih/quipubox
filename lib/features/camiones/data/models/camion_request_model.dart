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
      'placa': placa.trim(),
      if (_hasText(descripcion)) 'descripcion': descripcion!.trim(),
      if (_hasText(observaciones)) 'observaciones': observaciones!.trim(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'placa': placa.trim(),
      if (_hasText(descripcion)) 'descripcion': descripcion!.trim(),
      if (_hasText(observaciones)) 'observaciones': observaciones!.trim(),
    };
  }

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
