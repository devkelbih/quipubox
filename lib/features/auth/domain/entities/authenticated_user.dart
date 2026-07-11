import 'package:quipubox/features/auth/domain/entities/auth_sede.dart';

import '../../../company/domain/entities/empresa.dart';
import '../../../roles/domain/entities/role.dart';

/// Usuario autenticado de Quipubox.
///
/// Contiene únicamente información del dominio y algunas propiedades
/// derivadas para facilitar su representación en la interfaz.
class AuthenticatedUser {
  /// Identificador del usuario.
  final int id;

  /// Empresa a la que pertenece.
  final Empresa empresa;

  /// Sede asignada.
  final AuthSede sede;

  /// Roles asignados al usuario.
  final List<Role> roles;

  /// Correo electrónico.
  final String email;

  /// Nombre(s) registrados por la empresa.
  final String nombres;

  /// Apellido(s) registrados por la empresa.
  final String apellidos;

  /// Estado del usuario.
  final bool estado;

  /// Teléfono de contacto.
  final String? telefono;

  /// Fotografía del usuario.
  final String? avatarUrl;

  const AuthenticatedUser({
    required this.id,
    required this.empresa,
    required this.sede,
    required this.roles,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.estado,
    this.telefono,
    this.avatarUrl,
  });

  /// Nombre completo.
  ///
  /// Utilizado en pantallas donde se requiere mostrar la identidad completa,
  /// como el perfil del usuario.
  String get fullName =>
      '${nombres.trim()} ${apellidos.trim()}'.trim();

  /// Nombre resumido para espacios reducidos.
  ///
  /// Ejemplo:
  /// Juan Carlos + Pérez Gómez → Juan Pérez
  String get shortName {
    final firstName = nombres.trim().split(' ').first;

    final lastName = apellidos.trim().isEmpty
        ? ''
        : apellidos.trim().split(' ').first;

    return '$firstName $lastName'.trim();
  }

  /// Resumen compacto de los roles del usuario.
  ///
  /// Ejemplo:
  /// Repartidor +2
  String get rolesSummary {
    if (roles.isEmpty) return '-';

    if (roles.length == 1) {
      return roles.first.nombre;
    }

    return '${roles.first.nombre} +${roles.length - 1}';
  }

  /// Identificador de la empresa.
  int get idEmpresa => empresa.id;

  /// Identificador de la sede.
  int get idSede => sede.id;

  /// Identificadores de todos los roles.
  List<int> get roleIds => roles.map((role) => role.id).toList();

  /// Nombres de todos los roles.
  List<String> get roleNames => roles.map((role) => role.nombre).toList();

  /// Indica si el usuario posee un rol según su identificador.
  bool hasRoleId(int roleId) {
    return roles.any((role) => role.id == roleId);
  }

  /// Indica si el usuario posee un rol según su nombre.
  ///
  /// La comparación ignora mayúsculas, minúsculas y espacios.
  bool hasRoleName(String roleName) {
    final normalizedRole = roleName.trim().toLowerCase();

    return roles.any(
      (role) => role.nombre.trim().toLowerCase() == normalizedRole,
    );
  }
}