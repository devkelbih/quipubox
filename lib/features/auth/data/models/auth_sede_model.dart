import '../../domain/entities/auth_sede.dart';
import '../../../sedes/domain/enums/tipo_sede.dart';

class AuthSedeModel {
  final int id;
  final String nombre;
  final TipoSede tipoSede;
  final String? ciudad;
  final String? departamento;

  const AuthSedeModel({
    required this.id,
    required this.nombre,
    required this.tipoSede,
    this.ciudad,
    this.departamento,
  });

  factory AuthSedeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthSedeModel(
      id: json['id'] as int,
      nombre: json['nombre']?.toString() ?? '',
      tipoSede: TipoSede.fromValue(
        json['tipo_sede']?.toString() ?? '',
      ),
      ciudad: json['ciudad']?.toString(),
      departamento: json['departamento']?.toString(),
    );
  }

  factory AuthSedeModel.fromEntity(
    AuthSede sede,
  ) {
    return AuthSedeModel(
      id: sede.id,
      nombre: sede.nombre,
      tipoSede: sede.tipoSede,
      ciudad: sede.ciudad,
      departamento: sede.departamento,
    );
  }

  AuthSede toEntity() {
    return AuthSede(
      id: id,
      nombre: nombre,
      tipoSede: tipoSede,
      ciudad: ciudad,
      departamento: departamento,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo_sede': tipoSede.value,
      'ciudad': ciudad,
      'departamento': departamento,
    };
  }
}