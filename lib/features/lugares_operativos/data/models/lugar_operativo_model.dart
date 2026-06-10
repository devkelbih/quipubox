import '../../domain/entities/lugar_operativo.dart';
class LugarOperativoModel extends LugarOperativo {
  const LugarOperativoModel({required super.id, required super.idEmpresa, required super.estado, required super.idSede, required super.nombre, super.direccionReferencia, super.observaciones, required super.tipoLugar});
  factory LugarOperativoModel.fromJson(Map<String, dynamic> json) => LugarOperativoModel(id: json['id_lugar'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, idSede: json['id_sede'] as int? ?? 0,
nombre: json['nombre']?.toString() ?? '',
direccionReferencia: json['direccion_referencia']?.toString(),
observaciones: json['observaciones']?.toString(),
tipoLugar: json['tipo_lugar']?.toString() ?? '',);
  static List<LugarOperativoModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => LugarOperativoModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => LugarOperativoModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [LugarOperativoModel.fromJson(response)];
    return [];
  }
}
