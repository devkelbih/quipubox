class AppUser {
  final int id;
  final int idEmpresa;
  final int idSede;

  final List<int> roleIds;
  final List<String> roleNames;

  final String email;
  final String nombres;
  final String apellidos;
  final String estadoAcceso;
  final bool estado;

  final String? telefono;
  final String? avatarUrl;

  final String? empresaNombre;
  final String? razonSocial;
  final String? nombreComercial;
  final String? empresaRuc;

  final String? sedeNombre;

  const AppUser({
    required this.id,
    required this.idEmpresa,
    required this.idSede,
    required this.roleIds,
    required this.roleNames,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.estadoAcceso,
    required this.estado,
    this.telefono,
    this.avatarUrl,
    this.empresaNombre,
    this.razonSocial,
    this.nombreComercial,
    this.empresaRuc,
    this.sedeNombre,
  });

  String get fullName => '$nombres $apellidos'.trim();

  String get rolesText {
    if (roleNames.isEmpty) return '-';
    return roleNames.join(', ');
  }

  bool hasRoleId(int roleId) {
    return roleIds.contains(roleId);
  }

  bool hasRoleName(String roleName) {
    return roleNames.any(
      (name) => name.toLowerCase().trim() == roleName.toLowerCase().trim(),
    );
  }
}