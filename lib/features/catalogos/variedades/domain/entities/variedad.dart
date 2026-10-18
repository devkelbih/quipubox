import '../../../frutas/domain/entities/fruta.dart';

class Variedad {
  final int? id;
  final int? idEmpresa;

  /// FK utilizada para crear y actualizar.
  final int idFruta;

  /// Relación opcional cargada desde el backend.
  ///
  /// Puede venir nula durante create/update,
  /// pero normalmente existirá cuando proviene
  /// de un GET con join.
  final Fruta? fruta;

  final bool estado;
  final String nombre;
  final String? descripcion;

  const Variedad({
    this.id,
    this.idEmpresa,
    required this.idFruta,
    this.fruta,
    this.estado = true,
    required this.nombre,
    this.descripcion,
  });

  /// Helpers visuales para UI.
  String get frutaNombre => fruta?.nombre ?? '';

  bool get frutaActiva => fruta?.estado ?? true;

  Variedad copyWith({
    int? id,
    int? idEmpresa,
    int? idFruta,
    Fruta? fruta,
    bool? estado,
    String? nombre,
    String? descripcion,
  }) {
    return Variedad(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idFruta: idFruta ?? this.idFruta,
      fruta: fruta ?? this.fruta,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
    );
  }
}