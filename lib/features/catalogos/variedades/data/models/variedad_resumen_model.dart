import '../../domain/entities/variedad_resumen.dart';

class VariedadResumenModel {
  final int id;
  final String nombre;
  final bool estado;

  const VariedadResumenModel({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  factory VariedadResumenModel.fromJson(Map<String, dynamic> json) {
    return VariedadResumenModel(
      id: json['id_variedad'] as int,
      nombre: json['nombre']?.toString() ?? '',
      estado: json['estado'] == true,
    );
  }

  VariedadResumen toEntity() {
    return VariedadResumen(id: id, nombre: nombre, estado: estado);
  }
}
