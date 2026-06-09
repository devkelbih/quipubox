import '../../../core/constants/api_endpoints.dart';
import '../../../core/router/app_routes.dart';
import '../domain/entities/catalog_field.dart';
import '../domain/entities/catalog_module.dart';

class CatalogModules {
  const CatalogModules._();

  static final sedes = CatalogModule(
    title: 'Sedes',
    route: AppRoutes.sedes,
    getEndpoint: ApiEndpoints.sedes,
    postEndpoint: ApiEndpoints.sedes,
    patchEndpoint: ApiEndpoints.sedeById,
    fields: const [
      CatalogField(key: 'nombre', label: 'Nombre', required: true),
      CatalogField(key: 'tipo_sede', label: 'Tipo de sede', type: CatalogFieldType.select, required: true, options: ['origen', 'destino', 'ambos']),
      CatalogField(key: 'direccion', label: 'Dirección'),
      CatalogField(key: 'ciudad', label: 'Ciudad'),
      CatalogField(key: 'departamento', label: 'Departamento'),
    ],
    titleBuilder: (json) => json['nombre']?.toString() ?? 'Sede',
    subtitleBuilder: (json) => '${json['tipo_sede'] ?? ''} · ${json['ciudad'] ?? ''}',
  );

  static final roles = CatalogModule(
    title: 'Roles de usuarios',
    route: AppRoutes.roles,
    getEndpoint: ApiEndpoints.rolesUsuarios,
    postEndpoint: ApiEndpoints.rolesUsuarios,
    patchEndpoint: ApiEndpoints.rolUsuarioById,
    fields: const [
      CatalogField(key: 'nombre', label: 'Nombre', required: true),
      CatalogField(key: 'descripcion', label: 'Descripción', maxLines: 3),
    ],
    titleBuilder: (json) => json['nombre']?.toString() ?? 'Rol',
    subtitleBuilder: (json) => json['descripcion']?.toString() ?? '',
  );

  static final usuarios = CatalogModule(
    title: 'Usuarios',
    route: AppRoutes.usuarios,
    getEndpoint: ApiEndpoints.usuarios,
    postEndpoint: ApiEndpoints.usuarios,
    patchEndpoint: ApiEndpoints.usuarioById,
    fields: const [
      CatalogField(key: 'id_sede', label: 'ID sede', type: CatalogFieldType.number, required: true),
      CatalogField(key: 'nombres', label: 'Nombres', required: true),
      CatalogField(key: 'apellidos', label: 'Apellidos', required: true),
      CatalogField(key: 'telefono', label: 'Teléfono', type: CatalogFieldType.phone),
      CatalogField(key: 'email', label: 'Email', type: CatalogFieldType.email, required: true),
      CatalogField(key: 'google_uid', label: 'Google UID', required: true),
      CatalogField(key: 'avatar_url', label: 'Avatar URL', type: CatalogFieldType.url),
    ],
    titleBuilder: (json) => '${json['nombres'] ?? ''} ${json['apellidos'] ?? ''}'.trim(),
    subtitleBuilder: (json) => json['email']?.toString() ?? '',
  );

  static final clientes = CatalogModule(
    title: 'Clientes',
    route: AppRoutes.clientes,
    getEndpoint: ApiEndpoints.clientes,
    postEndpoint: ApiEndpoints.clientes,
    patchEndpoint: ApiEndpoints.clienteById,
    fields: const [
      CatalogField(key: 'nombres', label: 'Nombres', required: true),
      CatalogField(key: 'apellidos', label: 'Apellidos'),
      CatalogField(key: 'apodo', label: 'Apodo'),
      CatalogField(key: 'telefono', label: 'Teléfono', type: CatalogFieldType.phone),
      CatalogField(key: 'observaciones', label: 'Observaciones', maxLines: 3),
    ],
    titleBuilder: (json) => '${json['nombres'] ?? ''} ${json['apellidos'] ?? ''}'.trim(),
    subtitleBuilder: (json) => '${json['apodo'] ?? ''} · ${json['telefono'] ?? ''}',
  );

  static final frutas = CatalogModule(
    title: 'Frutas',
    route: AppRoutes.frutas,
    getEndpoint: ApiEndpoints.frutas,
    postEndpoint: ApiEndpoints.frutas,
    patchEndpoint: ApiEndpoints.frutaById,
    fields: const [
      CatalogField(key: 'nombre', label: 'Nombre', required: true),
      CatalogField(key: 'descripcion', label: 'Descripción', maxLines: 3),
    ],
    titleBuilder: (json) => json['nombre']?.toString() ?? 'Fruta',
    subtitleBuilder: (json) => json['descripcion']?.toString() ?? '',
  );

  static final variedades = CatalogModule(
    title: 'Variedades',
    route: AppRoutes.variedades,
    getEndpoint: ApiEndpoints.variedades,
    postEndpoint: ApiEndpoints.variedades,
    patchEndpoint: ApiEndpoints.variedadById,
    fields: const [
      CatalogField(key: 'id_fruta', label: 'ID fruta', type: CatalogFieldType.number, required: true),
      CatalogField(key: 'nombre', label: 'Nombre', required: true),
      CatalogField(key: 'descripcion', label: 'Descripción', maxLines: 3),
    ],
    titleBuilder: (json) => json['nombre']?.toString() ?? 'Variedad',
    subtitleBuilder: (json) => 'Fruta ID: ${json['id_fruta'] ?? '-'}',
  );

  static final calidades = CatalogModule(
    title: 'Calidades',
    route: AppRoutes.calidades,
    getEndpoint: ApiEndpoints.calidades,
    postEndpoint: ApiEndpoints.calidades,
    patchEndpoint: ApiEndpoints.calidadById,
    fields: const [
      CatalogField(key: 'nombre', label: 'Nombre', required: true),
      CatalogField(key: 'descripcion', label: 'Descripción', maxLines: 3),
    ],
    titleBuilder: (json) => json['nombre']?.toString() ?? 'Calidad',
    subtitleBuilder: (json) => json['descripcion']?.toString() ?? '',
  );

  static final tiposJaba = CatalogModule(
    title: 'Tipos de jaba',
    route: AppRoutes.tiposJaba,
    getEndpoint: ApiEndpoints.tiposJaba,
    postEndpoint: ApiEndpoints.tiposJaba,
    patchEndpoint: ApiEndpoints.tipoJabaById,
    fields: const [
      CatalogField(key: 'nombre', label: 'Nombre', required: true),
      CatalogField(key: 'tipo_material', label: 'Material', type: CatalogFieldType.select, required: true, options: ['madera', 'plastico']),
      CatalogField(key: 'descripcion', label: 'Descripción', maxLines: 3),
    ],
    titleBuilder: (json) => json['nombre']?.toString() ?? 'Tipo de jaba',
    subtitleBuilder: (json) => json['tipo_material']?.toString() ?? '',
  );

  static final camiones = CatalogModule(
    title: 'Camiones',
    route: AppRoutes.camiones,
    getEndpoint: ApiEndpoints.camiones,
    postEndpoint: ApiEndpoints.camiones,
    patchEndpoint: ApiEndpoints.camionById,
    fields: const [
      CatalogField(key: 'placa', label: 'Placa', required: true),
      CatalogField(key: 'descripcion', label: 'Descripción', maxLines: 2),
      CatalogField(key: 'observaciones', label: 'Observaciones', maxLines: 3),
    ],
    titleBuilder: (json) => json['placa']?.toString() ?? 'Camión',
    subtitleBuilder: (json) => json['descripcion']?.toString() ?? '',
  );

  static final mercados = CatalogModule(
    title: 'Lugares operativos',
    route: AppRoutes.mercados,
    getEndpoint: ApiEndpoints.mercados,
    postEndpoint: ApiEndpoints.mercados,
    patchEndpoint: ApiEndpoints.mercadoById,
    fields: const [
      CatalogField(key: 'id_sede', label: 'ID sede', type: CatalogFieldType.number, required: true),
      CatalogField(key: 'nombre', label: 'Nombre', required: true),
      CatalogField(key: 'tipo_lugar', label: 'Tipo de lugar', type: CatalogFieldType.select, required: true, options: ['mercado', 'almacen', 'calle', 'rampa', 'pasaje', 'cajoneria', 'otro']),
      CatalogField(key: 'direccion_referencia', label: 'Dirección o referencia'),
      CatalogField(key: 'observaciones', label: 'Observaciones', maxLines: 3),
    ],
    titleBuilder: (json) => json['nombre']?.toString() ?? 'Lugar operativo',
    subtitleBuilder: (json) => '${json['tipo_lugar'] ?? ''} · Sede ID: ${json['id_sede'] ?? '-'}',
  );

  static final puestos = CatalogModule(
    title: 'Puestos',
    route: AppRoutes.puestos,
    getEndpoint: ApiEndpoints.puestos,
    postEndpoint: ApiEndpoints.puestos,
    patchEndpoint: ApiEndpoints.puestoById,
    fields: const [
      CatalogField(key: 'id_lugar', label: 'ID lugar', type: CatalogFieldType.number, required: true),
      CatalogField(key: 'numero_puesto', label: 'Número de puesto', required: true),
      CatalogField(key: 'referencia', label: 'Referencia'),
    ],
    titleBuilder: (json) => json['numero_puesto']?.toString() ?? 'Puesto',
    subtitleBuilder: (json) => '${json['referencia'] ?? ''} · Lugar ID: ${json['id_lugar'] ?? '-'}',
  );

  static List<CatalogModule> get all => [
        sedes,
        roles,
        usuarios,
        clientes,
        frutas,
        variedades,
        calidades,
        tiposJaba,
        camiones,
        mercados,
        puestos,
      ];
}
