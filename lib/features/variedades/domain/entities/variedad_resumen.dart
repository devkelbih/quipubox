class VariedadResumen {
  final int id;
  final String nombre;
  final bool estado;

  const VariedadResumen({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  VariedadResumen copyWith({
    int? id,
    String? nombre,
    bool? estado,
  }) {
    return VariedadResumen(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
    );
  }
}