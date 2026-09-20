import '../../domain/entities/puesto.dart';

class PuestoRequestModel {
  final int? idEmpresa;
  final int? idLugar;
  final String numeroPuesto;
  final String? referencia;

  const PuestoRequestModel({
    this.idEmpresa,
    this.idLugar,
    required this.numeroPuesto,
    this.referencia,
  });

  factory PuestoRequestModel.fromEntity(Puesto item) {
    return PuestoRequestModel(
      idEmpresa: item.idEmpresa,
      idLugar: item.idLugar,
      numeroPuesto: item.numeroPuesto,
      referencia: item.referencia,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    if (idEmpresa != null) 'id_empresa': idEmpresa,
    if (idLugar != null) 'id_lugar': idLugar,
    if (numeroPuesto.trim().isNotEmpty) 'numero_puesto': numeroPuesto.trim(),
    if (referencia != null && referencia!.trim().isNotEmpty)
      'referencia': referencia!.trim(),
  };

  Map<String, dynamic> toUpdateJson() => {
    if (idLugar != null) 'id_lugar': idLugar,
    if (numeroPuesto.trim().isNotEmpty) 'numero_puesto': numeroPuesto.trim(),
    if (referencia != null && referencia!.trim().isNotEmpty)
      'referencia': referencia!.trim(),
  };
}
