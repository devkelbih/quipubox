import '../../../lugares_operativos/data/models/lugar_operativo_model.dart';
import '../../domain/entities/puesto.dart';

class PuestoModel {
  final int id;
  final int idEmpresa;
  final int idLugar;

  final LugarOperativoModel? lugarOperativo;

  final bool estado;
  final String numeroPuesto;
  final String? referencia;

  const PuestoModel({
    required this.id,
    required this.idEmpresa,
    required this.idLugar,
    this.lugarOperativo,
    required this.estado,
    required this.numeroPuesto,
    this.referencia,
  });

  /// Convierte el JSON recibido desde la API
  /// hacia un modelo de infraestructura.
  factory PuestoModel.fromJson(Map<String, dynamic> json) {
    final lugarJson = json['lugares_operativos'] is Map
        ? Map<String, dynamic>.from(json['lugares_operativos'] as Map)
        : null;

    return PuestoModel(
      id: json['id_puesto'] as int,
      idEmpresa: json['id_empresa'] as int,
      idLugar: json['id_lugar'] as int,
      lugarOperativo: lugarJson != null
          ? LugarOperativoModel.fromJson(lugarJson)
          : null,
      estado: json['estado'] == true,
      numeroPuesto: json['numero_puesto']?.toString() ?? '',
      referencia: json['referencia']?.toString(),
    );
  }

  /// Convierte el modelo hacia la entidad
  /// utilizada por la capa Domain.
  Puesto toEntity() {
    return Puesto(
      id: id,
      idEmpresa: idEmpresa,
      idLugar: idLugar,
      lugarOperativo: lugarOperativo?.toEntity(),
      estado: estado,
      numeroPuesto: numeroPuesto,
      referencia: referencia,
    );
  }
}
