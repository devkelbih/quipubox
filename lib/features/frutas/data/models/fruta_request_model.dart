class FrutaRequestModel {
  final int? idEmpresa;
  final String nombre;
final String? descripcion;
  const FrutaRequestModel({this.idEmpresa, required this.nombre, this.descripcion});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),};
  Map<String, dynamic> toUpdateJson() => {if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),};
}
