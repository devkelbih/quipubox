class UsuarioRequestModel {
  final int? idEmpresa;
  final int idSede;
final String nombres;
final String apellidos;
final String? telefono;
final String email;
  const UsuarioRequestModel({this.idEmpresa, required this.idSede, required this.nombres, required this.apellidos, this.telefono, required this.email});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, 'id_sede': idSede,
if (nombres.trim().isNotEmpty) 'nombres': nombres.trim(),
if (apellidos.trim().isNotEmpty) 'apellidos': apellidos.trim(),
if (telefono != null && telefono!.trim().isNotEmpty) 'telefono': telefono!.trim(),
if (email.trim().isNotEmpty) 'email': email.trim(),};
  Map<String, dynamic> toUpdateJson() => {'id_sede': idSede,
if (nombres.trim().isNotEmpty) 'nombres': nombres.trim(),
if (apellidos.trim().isNotEmpty) 'apellidos': apellidos.trim(),
if (telefono != null && telefono!.trim().isNotEmpty) 'telefono': telefono!.trim(),
if (email.trim().isNotEmpty) 'email': email.trim(),};
}
