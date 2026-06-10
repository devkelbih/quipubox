class ClienteRequestModel {
  final int? idEmpresa;
  final String nombres;
final String? apellidos;
final String? apodo;
final String telefono;
final String? observaciones;
  const ClienteRequestModel({this.idEmpresa, required this.nombres, this.apellidos, this.apodo, required this.telefono, this.observaciones});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, if (nombres.trim().isNotEmpty) 'nombres': nombres.trim(),
if (apellidos != null && apellidos!.trim().isNotEmpty) 'apellidos': apellidos!.trim(),
if (apodo != null && apodo!.trim().isNotEmpty) 'apodo': apodo!.trim(),
if (telefono.trim().isNotEmpty) 'telefono': telefono.trim(),
if (observaciones != null && observaciones!.trim().isNotEmpty) 'observaciones': observaciones!.trim(),};
  Map<String, dynamic> toUpdateJson() => {if (nombres.trim().isNotEmpty) 'nombres': nombres.trim(),
if (apellidos != null && apellidos!.trim().isNotEmpty) 'apellidos': apellidos!.trim(),
if (apodo != null && apodo!.trim().isNotEmpty) 'apodo': apodo!.trim(),
if (telefono.trim().isNotEmpty) 'telefono': telefono.trim(),
if (observaciones != null && observaciones!.trim().isNotEmpty) 'observaciones': observaciones!.trim(),};
}
