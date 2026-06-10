import '../../domain/entities/calidad.dart';
class CalidadModel extends Calidad {
  const CalidadModel({required super.id, required super.idEmpresa, required super.estado, required super.nombre, super.descripcion});
  factory CalidadModel.fromJson(Map<String, dynamic> json) => CalidadModel(id: json['id_calidad'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, nombre: json['nombre']?.toString() ?? '',
descripcion: json['descripcion']?.toString(),);
  static List<CalidadModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => CalidadModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => CalidadModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [CalidadModel.fromJson(response)];
    return [];
  }
}
