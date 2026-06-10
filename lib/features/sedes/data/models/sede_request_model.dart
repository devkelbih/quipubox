class SedeRequestModel {
  final int? idEmpresa;
  final String nombre;
final String tipoSede;
final String? direccion;
final String? ciudad;
final String? departamento;
  const SedeRequestModel({this.idEmpresa, required this.nombre, required this.tipoSede, this.direccion, this.ciudad, this.departamento});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (tipoSede.trim().isNotEmpty) 'tipo_sede': tipoSede.trim(),
if (direccion != null && direccion!.trim().isNotEmpty) 'direccion': direccion!.trim(),
if (ciudad != null && ciudad!.trim().isNotEmpty) 'ciudad': ciudad!.trim(),
if (departamento != null && departamento!.trim().isNotEmpty) 'departamento': departamento!.trim(),};
  Map<String, dynamic> toUpdateJson() => {if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
if (tipoSede.trim().isNotEmpty) 'tipo_sede': tipoSede.trim(),
if (direccion != null && direccion!.trim().isNotEmpty) 'direccion': direccion!.trim(),
if (ciudad != null && ciudad!.trim().isNotEmpty) 'ciudad': ciudad!.trim(),
if (departamento != null && departamento!.trim().isNotEmpty) 'departamento': departamento!.trim(),};
}
