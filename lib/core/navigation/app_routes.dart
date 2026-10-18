class AppRoutes {
  const AppRoutes._();

  // ---------------------------------------------------------------------------
  // Autenticación y Generales
  // ---------------------------------------------------------------------------
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const settings = '/settings';
  static const company = '/company';
  static const roles = '/roles';

  // Nombre base relativo para subrutas completas
  static const formSubRoute = 'form';

  // ---------------------------------------------------------------------------
  // Catálogos Simples (Sus formularios son BottomSheets, no requieren *Form)
  // ---------------------------------------------------------------------------
  static const sedes = '/sedes';
  static const lugaresOperativos = '/lugares-operativos';
  static const puestos = '/puestos';
  static const frutas = '/frutas';
  static const variedades = '/variedades';
  static const calidades = '/calidades';
  static const tiposJaba = '/tipos-jaba';
  static const camiones = '/camiones';

  // ---------------------------------------------------------------------------
  // Flujos Complejos (Navegan a pantalla completa vía GoRouter)
  // ---------------------------------------------------------------------------
  static const usuarios = '/usuarios';
  static const clientes = '/clientes';

  // Rutas Absolutas para context.push(...)
  static const usuariosForm = '$usuarios/$formSubRoute';
  static const clientesForm = '$clientes/$formSubRoute';
}