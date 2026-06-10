import 'package:flutter/foundation.dart';

import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.idEmpresa,
    required super.idSede,
    required super.roleIds,
    required super.roleNames,
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
    super.sedeNombre,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('PROFILE JSON => $json');

    final empresa = json['empresa'] is Map<String, dynamic>
        ? json['empresa'] as Map<String, dynamic>
        : <String, dynamic>{};

    final sede = json['sede'] is Map<String, dynamic>
        ? json['sede'] as Map<String, dynamic>
        : <String, dynamic>{};

    /// Obtiene la lista de roles del usuario.
    ///
    /// Actualmente el backend devuelve:
    ///
    /// {
    ///   "rol": {
    ///     "id": 1,
    ///     "nombre": "administrador"
    ///   }
    /// }
    ///
    /// Pero más adelante devolverá:
    ///
    /// {
    ///   "roles": [
    ///     { "id": 1, "nombre": "administrador" },
    ///     { "id": 2, "nombre": "supervisor" }
    ///   ]
    /// }
    ///
    /// Por eso usamos _readRoles().
    /// Este método soporta ambos formatos para no romper
    /// compatibilidad cuando el backend evolucione.
    final roles = _readRoles(json);

    final roleIds = roles
        .map((role) => _readRequiredInt(role['id'], 'roles.id'))
        .toList();

    final roleNames = roles
        .map((role) => role['nombre']?.toString().trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    final idEmpresa = _readRequiredInt(
      json['id_empresa'] ?? empresa['id'],
      'id_empresa',
    );

    final idSede = _readRequiredInt(sede['id'], 'sede.id');

    final nombreComercial = empresa['nombre_comercial']?.toString();
    final razonSocial = empresa['razon_social']?.toString();

    return AppUserModel(
      id: _readRequiredInt(json['id'], 'id'),
      idEmpresa: idEmpresa,
      idSede: idSede,
      roleIds: roleIds,
      roleNames: roleNames,
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
      sedeNombre: sede['nombre']?.toString(),
    );
  }

  /// Lee los roles del perfil soportando tanto
  /// el formato antiguo (rol) como el nuevo (roles).
  static List<Map<String, dynamic>> _readRoles(Map<String, dynamic> json) {
    /// Nuevo formato:
    ///
    /// "roles": [...]
    if (json['roles'] is List) {
      return (json['roles'] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    /// Formato antiguo:
    ///
    /// "rol": {...}
    if (json['rol'] is Map) {
      return [Map<String, dynamic>.from(json['rol'] as Map)];
    }

    /// Usuario sin roles.
    return [];
  }

  static int _readRequiredInt(dynamic value, String fieldName) {
    if (value is int) return value;

    final parsed = int.tryParse(value?.toString() ?? '');

    if (parsed != null) return parsed;

    throw Exception('El campo obligatorio $fieldName no llegó en el perfil.');
  }
}
