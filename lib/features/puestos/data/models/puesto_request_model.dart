class PuestoRequestModel {
  final int? idEmpresa;
  final int idLugar;
final String numeroPuesto;
final String? referencia;
  const PuestoRequestModel({this.idEmpresa, required this.idLugar, required this.numeroPuesto, this.referencia});
  Map<String, dynamic> toCreateJson() => {if (idEmpresa != null) 'id_empresa': idEmpresa, 'id_lugar': idLugar,
if (numeroPuesto.trim().isNotEmpty) 'numero_puesto': numeroPuesto.trim(),
if (referencia != null && referencia!.trim().isNotEmpty) 'referencia': referencia!.trim(),};
  Map<String, dynamic> toUpdateJson() => {'id_lugar': idLugar,
if (numeroPuesto.trim().isNotEmpty) 'numero_puesto': numeroPuesto.trim(),
if (referencia != null && referencia!.trim().isNotEmpty) 'referencia': referencia!.trim(),};
}
