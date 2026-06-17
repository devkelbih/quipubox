import '../../domain/entities/camion.dart';

class CamionModel extends Camion {
  const CamionModel({
    required super.id,
    required super.idEmpresa,
    required super.estado,
    required super.placa,
    super.descripcion,
    super.observaciones,
  });

  factory CamionModel.fromJson(Map<String, dynamic> json) {
    return CamionModel(
      id: json['id_camion'] as int? ?? 0,
      idEmpresa: json['id_empresa'] as int? ?? 0,
      estado: json['estado'] == true,
      placa: json['placa']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      observaciones: json['observaciones']?.toString(),
    );
  }

  static List<CamionModel> listFrom(dynamic response) {
    if (response is List) {
      return response
          .map((e) => CamionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .map((e) => CamionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (response is Map<String, dynamic>) {
      return [CamionModel.fromJson(response)];
    }

    return [];
  }
}