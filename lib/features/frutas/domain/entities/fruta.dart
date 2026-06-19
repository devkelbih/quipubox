class Fruta {
  final int? id;
  final int? idEmpresa;
  final bool estado;
  final String nombre;
  final String? descripcion;
  final String? empresaNombre;
  final int variedadesCount;

  const Fruta({
    this.id,
    this.idEmpresa,
    this.estado = true,
    required this.nombre,
    this.descripcion,
    this.empresaNombre,
    this.variedadesCount = 0,
  });

  Fruta copyWith({
    int? id,
    int? idEmpresa,
    bool? estado,
    String? nombre,
    String? descripcion,
    String? empresaNombre,
    int? variedadesCount,
  }) {
    return Fruta(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      empresaNombre: empresaNombre ?? this.empresaNombre,
      variedadesCount: variedadesCount ?? this.variedadesCount,
    );
  }
}
