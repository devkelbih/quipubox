import '../../domain/entities/calidad.dart';

class CalidadRequestModel {
  final int? idEmpresa;
  final String nombre;
  final String? descripcion;

  const CalidadRequestModel({
    this.idEmpresa,
    required this.nombre,
    this.descripcion,
  });

  factory CalidadRequestModel.fromEntity(Calidad item) {
    return CalidadRequestModel(
      idEmpresa: item.idEmpresa,
      nombre: item.nombre,
      descripcion: item.descripcion,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        if (idEmpresa != null) 'id_empresa': idEmpresa,
        if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
        if (descripcion != null && descripcion!.trim().isNotEmpty)
          'descripcion': descripcion!.trim(),
      };

  Map<String, dynamic> toUpdateJson() => {
        if (nombre.trim().isNotEmpty) 'nombre': nombre.trim(),
        if (descripcion != null && descripcion!.trim().isNotEmpty)
          'descripcion': descripcion!.trim(),
      };
}
