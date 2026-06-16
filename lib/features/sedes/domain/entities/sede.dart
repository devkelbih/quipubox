import '../enums/tipo_sede.dart';

class Sede {
  final int? id;
  final int? idEmpresa;
  final bool estado;
  final String nombre;
  final TipoSede tipoSede;
  final String? direccion;
  final String? ciudad;
  final String? departamento;

  const Sede({
    this.id,
    this.idEmpresa,
    this.estado = true,
    required this.nombre,
    required this.tipoSede,
    this.direccion,
    this.ciudad,
    this.departamento,
  });

  Sede copyWith({
    int? id,
    int? idEmpresa,
    bool? estado,
    String? nombre,
    TipoSede? tipoSede,
    String? direccion,
    String? ciudad,
    String? departamento,
  }) {
    return Sede(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      tipoSede: tipoSede ?? this.tipoSede,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      departamento: departamento ?? this.departamento,
    );
  }
}