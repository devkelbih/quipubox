import '../../domain/entities/tipos_jaba.dart';
import '../../domain/enums/tipo_material_jaba.dart';

class TipoJabaModel {
  final int id;
  final int idEmpresa;
  final bool estado;
  final String nombre;
  final TipoMaterialJaba tipoMaterial;
  final String? descripcion;
  const TipoJabaModel({
    required this.id,
    required this.idEmpresa,
    required this.estado,
    required this.nombre,
    required this.tipoMaterial,
    this.descripcion,
  });

  factory TipoJabaModel.fromJson(Map<String, dynamic> json) {
    return TipoJabaModel(
      id: json['id_tipo_jaba'] as int,
      idEmpresa: json['id_empresa'] as int,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      tipoMaterial: TipoMaterialJaba.fromValue(
        json['tipo_material']?.toString() ?? '',
      ),
      descripcion: json['descripcion']?.toString(),
    );
  }
  TipoJaba toEntity() => TipoJaba(
    id: id,
    idEmpresa: idEmpresa,
    estado: estado,
    nombre: nombre,
    tipoMaterial: tipoMaterial,
    descripcion: descripcion,
  );
}
