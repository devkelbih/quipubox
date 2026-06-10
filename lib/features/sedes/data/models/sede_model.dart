import '../../domain/entities/sede.dart';
class SedeModel extends Sede {
  const SedeModel({required super.id, required super.idEmpresa, required super.estado, required super.nombre, required super.tipoSede, super.direccion, super.ciudad, super.departamento});
  factory SedeModel.fromJson(Map<String, dynamic> json) => SedeModel(id: json['id_sede'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, nombre: json['nombre']?.toString() ?? '',
tipoSede: json['tipo_sede']?.toString() ?? '',
direccion: json['direccion']?.toString(),
ciudad: json['ciudad']?.toString(),
departamento: json['departamento']?.toString(),);
  static List<SedeModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => SedeModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => SedeModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [SedeModel.fromJson(response)];
    return [];
  }
}
