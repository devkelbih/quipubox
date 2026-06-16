import '../../domain/entities/empresa.dart';

class EmpresaModel extends Empresa {
  const EmpresaModel({
    required super.id,
    required super.razonSocial,
    required super.nombreComercial,
    required super.ruc,
    super.telefono,
    super.direccion,
    required super.estado,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id_empresa'] as int? ?? json['id'] as int? ?? 0,
      razonSocial: json['razon_social']?.toString() ?? '',
      nombreComercial: json['nombre_comercial']?.toString() ?? '',
      ruc: json['ruc']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      direccion: json['direccion']?.toString(),
      estado: json['estado'] == true,
    );
  }
}