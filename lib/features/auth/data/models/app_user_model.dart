import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.idEmpresa,
    required super.idRol,
    required super.idSede,
    required super.email,
    required super.nombres,
    required super.apellidos,
    required super.estadoAcceso,
    required super.estado,
    super.telefono,
    super.avatarUrl,
    super.empresaNombre,
    super.razonSocial,
    super.nombreComercial,
    super.empresaRuc,
    super.rolNombre,
    super.sedeNombre,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    final empresa = json['empresa'] is Map<String, dynamic>
        ? json['empresa'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rol = json['rol'] is Map<String, dynamic>
        ? json['rol'] as Map<String, dynamic>
        : <String, dynamic>{};

    final sede = json['sede'] is Map<String, dynamic>
        ? json['sede'] as Map<String, dynamic>
        : <String, dynamic>{};

    final idEmpresa = _readRequiredInt(
      json['id_empresa'] ?? empresa['id'],
      'id_empresa',
    );

    final idRol = _readRequiredInt(
      rol['id'],
      'rol.id',
    );

    final idSede = _readRequiredInt(
      sede['id'],
      'sede.id',
    );

    final nombreComercial = empresa['nombre_comercial']?.toString();
    final razonSocial = empresa['razon_social']?.toString();

    return AppUserModel(
      id: _readRequiredInt(json['id'], 'id'),
      idEmpresa: idEmpresa,
      idRol: idRol,
      idSede: idSede,
      email: json['email']?.toString() ?? '',
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      estadoAcceso: json['estado_acceso']?.toString() ?? 'bloqueado',
      estado: json['estado'] == true,
      empresaNombre: nombreComercial?.isNotEmpty == true
          ? nombreComercial
          : razonSocial,
      nombreComercial: nombreComercial,
      razonSocial: razonSocial,
      empresaRuc: empresa['ruc']?.toString(),
      rolNombre: rol['nombre']?.toString(),
      sedeNombre: sede['nombre']?.toString(),
    );
  }

  static int _readRequiredInt(dynamic value, String fieldName) {
    if (value is int) return value;

    final parsed = int.tryParse(value?.toString() ?? '');

    if (parsed != null) return parsed;

    throw Exception('El campo obligatorio $fieldName no llegó en el perfil.');
  }
}