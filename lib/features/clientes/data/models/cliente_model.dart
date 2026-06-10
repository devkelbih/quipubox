import '../../domain/entities/cliente.dart';
class ClienteModel extends Cliente {
  const ClienteModel({required super.id, required super.idEmpresa, required super.estado, required super.nombres, super.apellidos, super.apodo, required super.telefono, super.observaciones});
  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(id: json['id_cliente'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, nombres: json['nombres']?.toString() ?? '',
apellidos: json['apellidos']?.toString(),
apodo: json['apodo']?.toString(),
telefono: json['telefono']?.toString() ?? '',
observaciones: json['observaciones']?.toString(),);
  static List<ClienteModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => ClienteModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => ClienteModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [ClienteModel.fromJson(response)];
    return [];
  }
}
