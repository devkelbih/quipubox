import '../../../company/data/models/empresa_model.dart';
import '../../../roles/data/models/role_model.dart';
import '../../../sedes/data/models/sede_model.dart';
import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.empresa,
    required super.sede,
    required super.roles,
    required super.nombres,
    required super.apellidos,
    super.telefono,
    required super.email,
    super.googleUid,
    super.avatarUrl,
    required super.estadoAcceso,
    required super.estado,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    final empresaJson = json['empresas'] is Map
        ? Map<String, dynamic>.from(json['empresas'] as Map)
        : <String, dynamic>{};

    final sedeJson = json['sedes'] is Map
        ? Map<String, dynamic>.from(json['sedes'] as Map)
        : <String, dynamic>{};

    final rolesJson = _readRoles(json);

    return UsuarioModel(
      id: _readInt(json['id_usuario'] ?? json['id']),
      empresa: EmpresaModel.fromJson(empresaJson),
      sede: SedeModel.fromJson(sedeJson),
      roles: rolesJson.map(RoleModel.fromJson).toList(),
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString() ?? '',
      googleUid: json['google_uid']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      estadoAcceso: json['estado_acceso']?.toString() ?? 'activo',
      estado: json['estado'] == true,
    );
  }

  static List<Map<String, dynamic>> _readRoles(Map<String, dynamic> json) {
    final raw = json['usuarios_roles'] is List
        ? json['usuarios_roles'] as List
        : const [];

    return raw.whereType<Map>().map((item) {
      final itemMap = Map<String, dynamic>.from(item);

      if (itemMap['roles_usuarios'] is Map) {
        return Map<String, dynamic>.from(itemMap['roles_usuarios'] as Map);
      }

      return <String, dynamic>{};
    }).toList();
  }

  static List<UsuarioModel> listFrom(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map((e) => UsuarioModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
