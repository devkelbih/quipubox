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
    required super.estado,
    super.telefono,
    super.avatarUrl,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json, {String source = 'unknown'}) {
    debugPrint('PROFILE JSON [$source] => $json');

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
      estado: json['estado'] == true,
    );
  }

  factory AppUserModel.fromEntity(AppUser user) {
    return AppUserModel(
      id: user.id,
      empresa: user.empresa,
      sede: user.sede,
      roles: user.roles,
      email: user.email,
      nombres: user.nombres,
      apellidos: user.apellidos,
      telefono: user.telefono,
      avatarUrl: user.avatarUrl,
      estado: user.estado,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresa': _entityToJson(empresa),
      'sede': _entityToJson(sede),
      'roles': roles.map(_entityToJson).toList(),
      'email': email,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'avatar_url': avatarUrl,
      'estado': estado,
    };
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

  static Map<String, dynamic> _entityToJson(dynamic value) {
    if (value == null) return <String, dynamic>{};

    try {
      final json = value.toJson();

      if (json is Map<String, dynamic>) {
        return _jsonSafeMap(json);
      }

      if (json is Map) {
        return _jsonSafeMap(Map<String, dynamic>.from(json));
      }
    } on Object {
      // Fallback para entidades/modelos que todavía no tienen toJson().
    }

    return _fallbackEntityToJson(value);
  }

  static Map<String, dynamic> _fallbackEntityToJson(dynamic value) {
    final output = <String, dynamic>{};

    void add(String key, dynamic Function() getter) {
      try {
        final result = getter();

        if (result != null) {
          output[key] = _jsonSafe(result);
        }
      } on Object {
        // Campo inexistente en esta entidad.
      }
    }

    add('id', () => value.id);
    add('id_empresa', () => value.idEmpresa);
    add('id_sede', () => value.idSede);
    add('nombre', () => value.nombre);
    add('nombres', () => value.nombres);
    add('apellidos', () => value.apellidos);
    add('email', () => value.email);
    add('ruc', () => value.ruc);
    add('razon_social', () => value.razonSocial);
    add('nombre_comercial', () => value.nombreComercial);
    add('nombre_corto', () => value.nombreCorto);
    add('tipo_sede', () => value.tipoSede);
    add('ciudad', () => value.ciudad);
    add('departamento', () => value.departamento);
    add('descripcion', () => value.descripcion);
    add('estado', () => value.estado);

    return output;
  }

  static Map<String, dynamic> _jsonSafeMap(Map<String, dynamic> map) {
    return map.map(
      (key, value) => MapEntry(key, _jsonSafe(value)),
    );
  }

  static dynamic _jsonSafe(dynamic value) {
    if (value is Enum) {
      return value.name;
    }

    if (value is List) {
      return value.map(_jsonSafe).toList();
    }

    if (value is Map) {
      return value.map(
        (key, mapValue) => MapEntry(
          key.toString(),
          _jsonSafe(mapValue),
        ),
      );
    }

    return value;
  }
}