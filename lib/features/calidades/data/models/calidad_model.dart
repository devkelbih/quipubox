import '../../domain/entities/calidad.dart';

class CalidadModel {
  final int id;
  final int idEmpresa;
  final bool estado;
  final String nombre;
  final String? descripcion;
  const CalidadModel({
    required this.id,
    required this.idEmpresa,
    required this.estado,
    required this.nombre,
    this.descripcion,
  });

  factory CalidadModel.fromJson(Map<String, dynamic> json) {
    return CalidadModel(
      id: json['id_calidad'] as int,
      idEmpresa: json['id_empresa'] as int,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
    );
  }
  Calidad toEntity() => Calidad(
    id: id,
    idEmpresa: idEmpresa,
    estado: estado,
    nombre: nombre,
    descripcion: descripcion,
  );
}
