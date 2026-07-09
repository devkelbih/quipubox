import 'package:quipubox/features/variedades/data/models/variedad_resumen_model.dart';

import '../../domain/entities/fruta.dart';

class FrutaModel {
  final int id;
  final int idEmpresa;
  final bool estado;
  final String nombre;
  final String? descripcion;

  /// Relación opcional cargada desde el backend.
  ///
  /// Solo contiene información resumida de las
  /// variedades asociadas a la fruta para evitar
  /// referencias circulares entre entidades.
  final List<VariedadResumenModel>? variedades;

  const FrutaModel({
    required this.id,
    required this.idEmpresa,
    required this.estado,
    required this.nombre,
    this.descripcion,
    this.variedades,
  });

  /// Convierte el JSON recibido desde la API
  /// hacia un modelo de infraestructura.
  factory FrutaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final variedadesJson =
        json['variedades'] is List
            ? json['variedades'] as List
            : null;

    return FrutaModel(
      id: json['id_fruta'] as int,
      idEmpresa: json['id_empresa'] as int,
      estado: json['estado'] == true,
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      variedades: variedadesJson
          ?.map(
            (e) => VariedadResumenModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  /// Convierte el modelo hacia la entidad
  /// utilizada por la capa Domain.
  Fruta toEntity() {
    return Fruta(
      id: id,
      idEmpresa: idEmpresa,
      estado: estado,
      nombre: nombre,
      descripcion: descripcion,
      variedades: variedades
          ?.map((e) => e.toEntity())
          .toList(),
    );
  }
}