class UsuarioRequestModel {
  final int idEmpresa;
  final int idSede;
  final String nombres;
  final String apellidos;
  final String? telefono;
  final String email;
  final List<int> roleIds;

  const UsuarioRequestModel({
    required this.idEmpresa,
    required this.idSede,
    required this.nombres,
    required this.apellidos,
    this.telefono,
    required this.email,
    required this.roleIds,
  });

  Map<String, dynamic> toCreateJson() => {
        'id_empresa': idEmpresa,
        'id_sede': idSede,
        'nombres': nombres.trim(),
        if (apellidos.trim().isNotEmpty) 'apellidos': apellidos.trim(),
        if (telefono != null && telefono!.trim().isNotEmpty)
          'telefono': telefono!.trim(),
        'email': email.trim(),
        'roleIds': roleIds,
      };

  Map<String, dynamic> toUpdateJson() => {
        'id_sede': idSede,
        'nombres': nombres.trim(),
        if (apellidos.trim().isNotEmpty) 'apellidos': apellidos.trim(),
        if (telefono != null && telefono!.trim().isNotEmpty)
          'telefono': telefono!.trim(),
        'email': email.trim(),
        'roleIds': roleIds,
      };
}