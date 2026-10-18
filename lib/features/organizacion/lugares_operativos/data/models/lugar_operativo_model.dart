import '../../domain/entities/lugar_operativo.dart';
import '../../domain/enums/lugar_operativo_tipos.dart';
import '../../../sedes/data/models/sede_model.dart';

class LugarOperativoModel {
  final int id;
  final int idEmpresa;

  /// FK utilizada para crear y actualizar.
  final int idSede;

  /// Relación opcional cargada desde el backend.
  final SedeModel? sede;

  final bool estado;
  final String nombre;
  final String? direccionReferencia;
  final String? observaciones;
  final LugarOperativoTipos tipoLugar;

  const LugarOperativoModel({
    required this.id,
    required this.idEmpresa,
    required this.idSede,
    this.sede,
    required this.estado,
    required this.nombre,
    this.direccionReferencia,
    this.observaciones,
    required this.tipoLugar,
  });

  /// Convierte el JSON recibido desde la API
  /// hacia un modelo de infraestructura.
  ///
  /// Responsabilidades:
  /// - Procesar respuestas HTTP del backend.
  /// - Procesar datos serializados del almacenamiento local.
  /// - Normalizar tipos y valores nulos.
  ///
  /// Flujo típico:
  /// JSON -> Model
  factory LugarOperativoModel.fromJson(Map<String, dynamic> json) {
    final sedeJson = json['sedes'];

    return LugarOperativoModel(
      id: json['id_lugar'] as int,
      idEmpresa: json['id_empresa'] as int,
      idSede: json['id_sede'] as int,
      sede: sedeJson is Map<String, dynamic>
          ? SedeModel.fromJson(sedeJson)
          : null,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      direccionReferencia: json['direccion_referencia']?.toString(),
      observaciones: json['observaciones']?.toString(),
      tipoLugar: LugarOperativoTipos.fromValue(
        json['tipo_lugar']?.toString() ?? '',
      ),
    );
  }

  /// Convierte el modelo de infraestructura
  /// hacia la entidad de dominio.
  ///
  /// La capa Domain nunca debe depender
  /// de modelos pertenecientes a la capa Data.
  ///
  /// Flujo típico:
  /// API -> Model -> Entity
  LugarOperativo toEntity() {
    return LugarOperativo(
      id: id,
      idEmpresa: idEmpresa,
      idSede: idSede,
      sede: sede?.toEntity(),
      estado: estado,
      nombre: nombre,
      direccionReferencia: direccionReferencia,
      observaciones: observaciones,
      tipoLugar: tipoLugar,
    );
  }
}
