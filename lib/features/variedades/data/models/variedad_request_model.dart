class VariedadRequestModel {
  final int? idEmpresa;
  final int idFruta;
final String nombre;
final String? descripcion;
  const VariedadRequestModel({this.idEmpresa, required this.idFruta, required this.nombre, this.descripcion});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, 'id_fruta': idFruta,
if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),};
  Map<String, dynamic> toUpdateJson() => {'id_fruta': idFruta,
if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),};
}
