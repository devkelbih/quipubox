class TipoJabaRequestModel {
  final int? idEmpresa;
  final String nombre;
final String tipoMaterial;
final String? descripcion;
  const TipoJabaRequestModel({this.idEmpresa, required this.nombre, required this.tipoMaterial, this.descripcion});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (tipoMaterial.trim().isNotEmpty) 'tipo_material': tipoMaterial.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),};
  Map<String, dynamic> toUpdateJson() => {if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (tipoMaterial.trim().isNotEmpty) 'tipo_material': tipoMaterial.trim(),
if (descripcion != null && descripcion!.trim().isNotEmpty) 'descripcion': descripcion!.trim(),};
}
