class Variedad {
  final int? id;
  final int? idEmpresa;
  final int? idFruta;
  final bool estado;
  final String nombre;
  final String? descripcion;
  final String? frutaNombre;
  final String? empresaNombre;

  const Variedad({
    this.id,
    this.idEmpresa,
    this.idFruta,
    this.estado = true,
    required this.nombre,
    this.descripcion,
    this.frutaNombre,
    this.empresaNombre,
  });

  Variedad copyWith({
    int? id,
    int? idEmpresa,
    int? idFruta,
    bool? estado,
    String? nombre,
    String? descripcion,
    String? frutaNombre,
    String? empresaNombre,
  }) {
    return Variedad(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idFruta: idFruta ?? this.idFruta,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      frutaNombre: frutaNombre ?? this.frutaNombre,
      empresaNombre: empresaNombre ?? this.empresaNombre,
    );
  }
}
