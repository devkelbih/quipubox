class Calidad {
  final int? id;
  final int? idEmpresa;
  final bool estado;
  final String nombre;
  final String? descripcion;
  final String? empresaNombre;

  const Calidad({
    this.id,
    this.idEmpresa,
    this.estado = true,
    required this.nombre,
    this.descripcion,
    this.empresaNombre,
  });

  Calidad copyWith({
    int? id,
    int? idEmpresa,
    bool? estado,
    String? nombre,
    String? descripcion,
    String? empresaNombre,
  }) {
    return Calidad(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      empresaNombre: empresaNombre ?? this.empresaNombre,
    );
  }
}
