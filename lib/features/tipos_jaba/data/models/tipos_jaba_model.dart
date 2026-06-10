import '../../domain/entities/tipos_jaba.dart';
class TipoJabaModel extends TipoJaba {
  const TipoJabaModel({required super.id, required super.idEmpresa, required super.estado, required super.nombre, required super.tipoMaterial, super.descripcion});
  factory TipoJabaModel.fromJson(Map<String, dynamic> json) => TipoJabaModel(id: json['id_tipos_jaba'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, nombre: json['nombre']?.toString() ?? '',
tipoMaterial: json['tipo_material']?.toString() ?? '',
descripcion: json['descripcion']?.toString(),);
  static List<TipoJabaModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => TipoJabaModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => TipoJabaModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [TipoJabaModel.fromJson(response)];
    return [];
  }
}
