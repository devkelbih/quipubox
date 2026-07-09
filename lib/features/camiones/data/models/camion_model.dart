import '../../domain/entities/camion.dart';

class CamionModel {
  final int id;
  final int idEmpresa;
  final bool estado;
  final String placa;
  final String? descripcion;
  final String? observaciones;
  const CamionModel({
    required this.id,
    required this.idEmpresa,
    required this.estado,
    required this.placa,
    this.descripcion,
    this.observaciones,
  });

  factory CamionModel.fromJson(Map<String, dynamic> json) {
    return CamionModel(
      id: json['id_camion'] as int,
      idEmpresa: json['id_empresa'] as int,
      estado: json['estado'] == true,
      placa: json['placa']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      observaciones: json['observaciones']?.toString(),
    );
  }
  Camion toEntity() => Camion(
    id: id,
    idEmpresa: idEmpresa,
    estado: estado,
    placa: placa,
    descripcion: descripcion,
    observaciones: observaciones,
  );
}
