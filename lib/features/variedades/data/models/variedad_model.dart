import '../../domain/entities/variedad.dart';
class VariedadModel extends Variedad {
  const VariedadModel({required super.id, required super.idEmpresa, required super.estado, required super.idFruta, required super.nombre, super.descripcion});
  factory VariedadModel.fromJson(Map<String, dynamic> json) => VariedadModel(id: json['id_variedad'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, idFruta: json['id_fruta'] as int? ?? 0,
nombre: json['nombre']?.toString() ?? '',
descripcion: json['descripcion']?.toString(),);
  static List<VariedadModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => VariedadModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => VariedadModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [VariedadModel.fromJson(response)];
    return [];
  }
}
