import '../../domain/entities/tipos_jaba.dart';

class TipoJabaRequestModel {
  final int? idEmpresa;
  final String nombre;
  final String tipoMaterial;
  final String? descripcion;

  const TipoJabaRequestModel({
    this.idEmpresa,
    required this.nombre,
    required this.tipoMaterial,
    this.descripcion,
  });

  factory TipoJabaRequestModel.fromEntity(TipoJaba item) {
    return TipoJabaRequestModel(
      idEmpresa: item.idEmpresa,
      nombre: item.nombre,
      tipoMaterial: item.tipoMaterial.value,
      descripcion: item.descripcion,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        if (idEmpresa != null) 'id_empresa': idEmpresa,
        if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
        if (tipoMaterial.trim().isNotEmpty) 'tipo_material': tipoMaterial.trim(),
        if (descripcion != null && descripcion!.trim().isNotEmpty)
          'descripcion': descripcion!.trim(),
      };

  Map<String, dynamic> toUpdateJson() => {
        if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
        if (tipoMaterial.trim().isNotEmpty) 'tipo_material': tipoMaterial.trim(),
        if (descripcion != null && descripcion!.trim().isNotEmpty)
          'descripcion': descripcion!.trim(),
      };
}