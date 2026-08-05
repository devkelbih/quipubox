import '../../../variedades/domain/entities/variedad_resumen.dart';

class Fruta {
  final int? id;
  final int? idEmpresa;

  final bool estado;
  final String nombre;
  final String? descripcion;

  /// Relación opcional cargada desde el backend.
  ///
  /// Se utiliza únicamente para mostrar información
  /// resumida de las variedades asociadas a la fruta.
  final List<VariedadResumen>? variedades;

  const Fruta({
    this.id,
    this.idEmpresa,
    this.estado = true,
    required this.nombre,
    this.descripcion,
    this.variedades,
  });

  /// Cantidad total de variedades asociadas.
  int get totalVariedades => variedades?.length ?? 0;


  Fruta copyWith({
    int? id,
    int? idEmpresa,
    bool? estado,
    String? nombre,
    String? descripcion,
    List<VariedadResumen>? variedades,
  }) {
    return Fruta(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      variedades: variedades ?? this.variedades,
    );
  }
}
