import '../../../frutas/data/models/fruta_model.dart';
import '../../domain/entities/variedad.dart';

class VariedadModel {
  final int id;
  final int idEmpresa;
  final int idFruta;

  final FrutaModel? fruta;

  final bool estado;
  final String nombre;
  final String? descripcion;

  const VariedadModel({
    required this.id,
    required this.idEmpresa,
    required this.idFruta,
    this.fruta,
    required this.estado,
    required this.nombre,
    this.descripcion,
  });

  /// Convierte el JSON recibido desde la API
  /// hacia un modelo de infraestructura.
  factory VariedadModel.fromJson(Map<String, dynamic> json) {
    final frutaJson = json['frutas'] is Map
        ? Map<String, dynamic>.from(json['frutas'] as Map)
        : null;

    return VariedadModel(
      id: json['id_variedad'] as int,
      idEmpresa: json['id_empresa'] as int,
      idFruta: json['id_fruta'] as int,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      fruta: frutaJson != null ? FrutaModel.fromJson(frutaJson) : null,
    );
  }

  /// Convierte el modelo hacia la entidad
  /// utilizada por la capa Domain.
  Variedad toEntity() {
    return Variedad(
      id: id,
      idEmpresa: idEmpresa,
      idFruta: idFruta,
      fruta: fruta?.toEntity(),
      estado: estado,
      nombre: nombre,
      descripcion: descripcion,
    );
  }
}
