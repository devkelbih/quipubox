import '../../../company/data/models/empresa_model.dart';
import '../../../roles/data/models/role_model.dart';
import '../../../sedes/data/models/sede_model.dart';
import '../../domain/entities/usuario.dart';

class UsuarioModel {
  final int id;
  final EmpresaModel empresa;
  final SedeModel sede;
  final List<RoleModel> roles;

  final String nombres;
  final String? apellidos;
  final String? telefono;
  final String email;

  final String? googleUid;
  final String? avatarUrl;

  final bool estado;

  const UsuarioModel({
    required this.id,
    required this.empresa,
    required this.sede,
    required this.roles,
    required this.nombres,
    this.apellidos,
    this.telefono,
    required this.email,
    this.googleUid,
    this.avatarUrl,
    required this.estado,
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
      apellidos: _readNullableString(json['apellidos']),
      telefono: _readNullableString(json['telefono']),
      email: json['email']?.toString() ?? '',
      googleUid: _readNullableString(json['google_uid']),
      avatarUrl: _readNullableString(json['avatar_url']),
      estado: json['estado'] == true,
    );
  }

  Usuario toEntity() {
    return Usuario(
      id: id,
      empresa: empresa.toEntity(),
      sede: sede.toEntity(),
      roles: roles.map((e) => e.toEntity()).toList(),
      nombres: nombres,
      apellidos: apellidos,
      telefono: telefono,
      email: email,
      googleUid: googleUid,
      avatarUrl: avatarUrl,
      estado: estado,
    );
  }

  static List<UsuarioModel> listFrom(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map((e) => UsuarioModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
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

  static int _readInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String? _readNullableString(dynamic value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }
}
