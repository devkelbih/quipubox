import '../../domain/entities/usuario.dart';
class UsuarioModel extends Usuario {
  const UsuarioModel({required super.id, required super.idEmpresa, required super.estado, required super.idSede, required super.nombres, required super.apellidos, super.telefono, required super.email});
  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(id: json['id_usuario'] as int? ?? 0, idEmpresa: json['id_empresa'] as int? ?? 1, estado: json['estado'] == true, idSede: json['id_sede'] as int? ?? 0,
nombres: json['nombres']?.toString() ?? '',
apellidos: json['apellidos']?.toString() ?? '',
telefono: json['telefono']?.toString(),
email: json['email']?.toString() ?? '',);
  static List<UsuarioModel> listFrom(dynamic response) {
    if (response is List) return response.map((e) => UsuarioModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic> && response['data'] is List) return (response['data'] as List).map((e) => UsuarioModel.fromJson(e as Map<String, dynamic>)).toList();
    if (response is Map<String, dynamic>) return [UsuarioModel.fromJson(response)];
    return [];
  }
}
