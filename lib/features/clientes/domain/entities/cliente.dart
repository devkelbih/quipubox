import 'cliente_puesto.dart';
import 'cliente_sede.dart';

class Cliente {
  final int? id;

  final int? idEmpresa;

  final String nombres;
  final String? apellidos;
  final String? apodo;
  final String? telefono;
  final String? observaciones;

  final bool estado;

  /// Relaciones Cliente ↔ Sede.
  final List<ClienteSede> sedes;

  /// Relaciones Cliente ↔ Puesto.
  final List<ClientePuesto> puestos;

  const Cliente({
    this.id,
    this.idEmpresa,
    required this.nombres,
    this.apellidos,
    this.apodo,
    this.telefono,
    this.observaciones,
    this.estado = true,
    this.sedes = const [],
    this.puestos = const [],
  });

  String get nombreCompleto => '$nombres ${apellidos ?? ''}'.trim();

  Cliente copyWith({
    int? id,
    int? idEmpresa,
    String? nombres,
    String? apellidos,
    String? apodo,
    String? telefono,
    String? observaciones,
    bool? estado,
    List<ClienteSede>? sedes,
    List<ClientePuesto>? puestos,
  }) {
    return Cliente(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      apodo: apodo ?? this.apodo,
      telefono: telefono ?? this.telefono,
      observaciones: observaciones ?? this.observaciones,
      estado: estado ?? this.estado,
      sedes: sedes ?? this.sedes,
      puestos: puestos ?? this.puestos,
    );
  }
}