import '../../domain/entities/fruta.dart';
class FrutaModel extends Fruta {
  const FrutaModel({required super.id, required super.idEmpresa, required super.estado, required super.nombre, super.descripcion});
  factory FrutaModel.fromJson(Map<String, dynamic> json) => FrutaModel(id: json['id_fruta'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, nombre: json['nombre']?.toString() ?? '',
descripcion: json['descripcion']?.toString(),);
  static List<FrutaModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => FrutaModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => FrutaModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [FrutaModel.fromJson(response)];
    return [];
  }
}
