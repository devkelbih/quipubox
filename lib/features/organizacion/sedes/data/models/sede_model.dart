import '../../domain/entities/sede.dart';
import '../../domain/enums/tipo_sede.dart';

class SedeModel {
  final int id;
  final int idEmpresa;
  final bool estado;
  final String nombre;
  final TipoSede tipoSede;
  final String? direccion;
  final String? ciudad;
  final String? departamento;

  const SedeModel({
    required this.id,
    required this.idEmpresa,
    required this.estado,
    required this.nombre,
    required this.tipoSede,
    this.direccion,
    this.ciudad,
    this.departamento,
  });

  /// Convierte el JSON recibido desde la API
  /// o desde cache local en un modelo de infraestructura.
  ///
  /// Responsabilidades:
  /// - Procesar respuestas HTTP del backend.
  /// - Procesar datos serializados del almacenamiento local.
  /// - Normalizar tipos y valores nulos.
  ///
  /// Flujo típico:
  /// JSON -> Model
  factory SedeModel.fromJson(Map<String, dynamic> json) {
    return SedeModel(
      id: json['id_sede'] as int,
      idEmpresa: json['id_empresa'] as int,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      tipoSede: TipoSede.fromValue(json['tipo_sede']?.toString() ?? ''),
      direccion: json['direccion']?.toString(),
      ciudad: json['ciudad']?.toString(),
      departamento: json['departamento']?.toString(),
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
  Sede toEntity() {
    return Sede(
      id: id,
      idEmpresa: idEmpresa,
      estado: estado,
      nombre: nombre,
      tipoSede: tipoSede,
      direccion: direccion,
      ciudad: ciudad,
      departamento: departamento,
    );
  }
}
