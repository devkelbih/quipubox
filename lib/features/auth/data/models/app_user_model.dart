import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({required super.id, required super.idEmpresa, required super.email, required super.nombres, required super.apellidos, required super.estadoAcceso, required super.estado, super.telefono, super.avatarUrl, super.empresaNombre, super.rolNombre, super.sedeNombre});

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresa'] is Map<String, dynamic> ? json['empresa'] as Map<String, dynamic> : <String, dynamic>{};
    final rol = json['rol'] is Map<String, dynamic> ? json['rol'] as Map<String, dynamic> : <String, dynamic>{};
    final sede = json['sede'] is Map<String, dynamic> ? json['sede'] as Map<String, dynamic> : <String, dynamic>{};
    return AppUserModel(
      id: json['id'] as int? ?? 0,
      idEmpresa: json['id_empresa'] as int? ?? 1,
      email: json['email']?.toString() ?? '',
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      estadoAcceso: json['estado_acceso']?.toString() ?? 'bloqueado',
      estado: json['estado'] == true,
      empresaNombre: empresa['nombre_comercial']?.toString() ?? empresa['razon_social']?.toString(),
      rolNombre: rol['nombre']?.toString(),
      sedeNombre: sede['nombre']?.toString(),
    );
  }
}
