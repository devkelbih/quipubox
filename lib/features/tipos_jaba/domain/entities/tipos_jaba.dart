import '../enums/tipo_material_jaba.dart';

class TipoJaba {
  final int? id;
  final int? idEmpresa;
  final bool estado;
  final String nombre;
  final TipoMaterialJaba tipoMaterial;
  final String? descripcion;
  final String? empresaNombre;

  const TipoJaba({
    this.id,
    this.idEmpresa,
    this.estado = true,
    required this.nombre,
    required this.tipoMaterial,
    this.descripcion,
    this.empresaNombre,
  });

  TipoJaba copyWith({
    int? id,
    int? idEmpresa,
    bool? estado,
    String? nombre,
    TipoMaterialJaba? tipoMaterial,
    String? descripcion,
    String? empresaNombre,
  }) {
    return TipoJaba(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      tipoMaterial: tipoMaterial ?? this.tipoMaterial,
      descripcion: descripcion ?? this.descripcion,
      empresaNombre: empresaNombre ?? this.empresaNombre,
    );
  }
}