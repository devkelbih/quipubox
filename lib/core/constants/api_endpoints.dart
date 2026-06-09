class ApiEndpoints {
  const ApiEndpoints._();

  static const empresas = '/empresas';
  static String empresaById(int id) => '/empresas/$id';

  static const sedes = '/sedes';
  static String sedeById(int id) => '/sedes/$id';

  static const rolesUsuarios = '/roles-usuarios';
  static String rolUsuarioById(int id) => '/roles-usuarios/$id';

  static const usuarios = '/usuarios';
  static String usuarioById(int id) => '/usuarios/$id';
  static String bloquearUsuario(int id) => '/usuarios/$id/bloquear';
  static String activarUsuario(int id) => '/usuarios/$id/activar';
  static const usuariosRoles = '/usuarios-roles';

  static const clientes = '/clientes';
  static String clienteById(int id) => '/clientes/$id';

  static const frutas = '/frutas';
  static String frutaById(int id) => '/frutas/$id';

  static const variedades = '/variedades';
  static String variedadById(int id) => '/variedades/$id';

  static const calidades = '/calidades';
  static String calidadById(int id) => '/calidades/$id';

  static const tiposJaba = '/tipos-jaba';
  static String tipoJabaById(int id) => '/tipos-jaba/$id';

  static const camiones = '/camiones';
  static String camionById(int id) => '/camiones/$id';

  static const mercados = '/mercados';
  static String mercadoById(int id) => '/mercados/$id';

  static const puestos = '/puestos';
  static String puestoById(int id) => '/puestos/$id';
}
