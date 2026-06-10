class CamionRequestModel {
  final int? idEmpresa;
  final String placa;
final String? descripcion;
final String? observaciones;
  const CamionRequestModel({this.idEmpresa, required this.placa, this.descripcion, this.observaciones});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, if (placa.trim().isNotEmpty) 'placa': placa.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),
if (observaciones != null && observaciones!.trim().isNotEmpty) 'observaciones': observaciones!.trim(),};
  Map<String, dynamic> toUpdateJson() => {if (placa.trim().isNotEmpty) 'placa': placa.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),
if (observaciones != null && observaciones!.trim().isNotEmpty) 'observaciones': observaciones!.trim(),};
}
