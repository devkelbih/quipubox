import '../../domain/entities/empresa.dart';

class EmpresaModel {
  final int id;
  final String razonSocial;
  final String nombreComercial;
  final String ruc;
  final String? telefono;
  final String? direccion;
  final bool estado;

  const EmpresaModel({
    required this.id,
    required this.razonSocial,
    required this.nombreComercial,
    required this.ruc,
    this.telefono,
    this.direccion,
    required this.estado,
  });

  /// Convierte el modelo de infraestructura
  /// hacia la entidad de dominio.
  ///
  /// La capa Domain nunca debe depender
  /// de modelos pertenecientes a la capa Data.
  ///
  /// Responsabilidades:
  /// - Entregar objetos puros de dominio.
  /// - Eliminar dependencias hacia la capa Data.
  /// - Mantener el aislamiento de la arquitectura limpia.
  ///
  /// Flujo típico:
  /// API -> Model -> Entity
  ///
  /// Ejemplos:
  /// - Repository -> UseCase
  /// - UseCase -> ViewModel
  /// - ViewModel -> UI
  Empresa toEntity() {
    return Empresa(
      id: id,
      razonSocial: razonSocial,
      nombreComercial: nombreComercial,
      ruc: ruc,
      telefono: telefono,
      direccion: direccion,
      estado: estado,
    );
  }

  /// Convierte el JSON recibido desde la API
  /// o desde cache local en un modelo de infraestructura.
  ///
  /// Responsabilidades:
  /// - Procesar respuestas HTTP del backend.
  /// - Procesar datos serializados del almacenamiento local.
  /// - Normalizar tipos y valores nulos.
  ///
  /// Se soportan múltiples nombres de ID debido a que
  /// algunas respuestas del backend utilizan:
  ///
  /// - id_empresa
  /// - id
  ///
  /// Flujo típico:
  /// JSON -> Model
  factory EmpresaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmpresaModel(
      id: json['id_empresa'] as int? ??
          json['id'] as int? ??
          0,
      razonSocial:
          json['razon_social']?.toString() ?? '',
      nombreComercial:
          json['nombre_comercial']?.toString() ?? '',
      ruc: json['ruc']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      direccion: json['direccion']?.toString(),
      estado: json['estado'] == true,
    );
  }

  /// Convierte una entidad de dominio
  /// nuevamente hacia un modelo de infraestructura.
  ///
  /// Este método NO se utiliza para crear
  /// ni actualizar empresas mediante la API.
  ///
  /// Las empresas dentro de Quipubox funcionan
  /// como un catálogo maestro del sistema y
  /// actualmente no poseen operaciones CRUD
  /// desde la aplicación móvil.
  ///
  /// Este método existe únicamente para:
  /// - Cache local.
  /// - Persistencia.
  /// - Serialización.
  /// - Auth y sesión.
  /// - Construcción de modelos complejos anidados.
  ///
  /// Ejemplos:
  /// - AppUserModel.fromEntity()
  /// - UsuarioModel.fromEntity()
  /// - Guardado de sesión local.
  ///
  /// En este contexto la entidad ya representa
  /// un registro persistido proveniente del backend,
  /// por lo que el ID siempre existe y no es nullable.
  ///
  /// Flujo típico:
  /// Entity persistida -> Model -> Cache/JSON
  factory EmpresaModel.fromEntity(
    Empresa empresa,
  ) {
    return EmpresaModel(
      id: empresa.id,
      razonSocial: empresa.razonSocial,
      nombreComercial: empresa.nombreComercial,
      ruc: empresa.ruc,
      telefono: empresa.telefono,
      direccion: empresa.direccion,
      estado: empresa.estado,
    );
  }
}