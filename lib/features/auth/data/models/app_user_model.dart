import 'package:flutter/foundation.dart';

import '../../../company/data/models/empresa_model.dart';
import '../../../roles/data/models/role_model.dart';
import '../../../sedes/data/models/sede_model.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.empresa,
    required super.sede,
    required super.roles,
    required super.email,
    required super.nombres,
    required super.apellidos,
    required super.estadoAcceso,
    required super.estado,
    super.telefono,
    super.avatarUrl,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('PROFILE JSON => $json');

    final empresaJson = json['empresa'] is Map
        ? Map<String, dynamic>.from(json['empresa'] as Map)
        : <String, dynamic>{};

    final sedeJson = json['sede'] is Map
        ? Map<String, dynamic>.from(json['sede'] as Map)
        : <String, dynamic>{};

    final rolesJson = _readRoles(json);

    return AppUserModel(
      id: _readInt(json['id']),
      empresa: EmpresaModel.fromJson(empresaJson),
      sede: SedeModel.fromJson(sedeJson),
      roles: rolesJson.map(RoleModel.fromJson).toList(),
      email: json['email']?.toString() ?? '',
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      estadoAcceso: json['estado_acceso']?.toString() ?? 'bloqueado',
      estado: json['estado'] == true,
    );
  }

  static List<Map<String, dynamic>> _readRoles(Map<String, dynamic> json) {
    if (json['roles'] is List) {
      return (json['roles'] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (json['rol'] is Map) {
      return [Map<String, dynamic>.from(json['rol'] as Map)];
    }

    return [];
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}