import '../../../lugares_operativos/domain/entities/lugar_operativo.dart';

class Puesto {
  final int? id;
  final int? idEmpresa;

  /// FK utilizada para crear y actualizar.
  final int idLugar;

  /// Relación opcional cargada desde el backend.
  ///
  /// Puede venir nula durante create/update,
  /// pero normalmente existirá cuando proviene
  /// de un GET con join.
  final LugarOperativo? lugarOperativo;

  final bool estado;
  final String numeroPuesto;
  final String? referencia;

  const Puesto({
    this.id,
    this.idEmpresa,
    required this.idLugar,
    this.lugarOperativo,
    this.estado = true,
    required this.numeroPuesto,
    this.referencia,
  });

  /// Helpers visuales para UI.
  String get lugarNombre => lugarOperativo?.nombre ?? '';

  String get sedeNombre => lugarOperativo?.sede?.nombre ?? '';

  String get tipoLugarNombre => lugarOperativo?.tipoLugar.label ?? '';

  bool get lugarActivo => lugarOperativo?.estado ?? true;

  Puesto copyWith({
    int? id,
    int? idEmpresa,
    int? idLugar,
    LugarOperativo? lugarOperativo,
    bool? estado,
    String? numeroPuesto,
    String? referencia,
  }) {
    return Puesto(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idLugar: idLugar ?? this.idLugar,
      lugarOperativo: lugarOperativo ?? this.lugarOperativo,
      estado: estado ?? this.estado,
      numeroPuesto: numeroPuesto ?? this.numeroPuesto,
      referencia: referencia ?? this.referencia,
    );
  }
}