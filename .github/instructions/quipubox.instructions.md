---
description: "Usa estas instrucciones al modificar la aplicación Flutter, funcionalidades de Dart, navegación, gestión de estado, networking o configuración móvil."
applyTo: "quipubox/**"
---
# Guía de Flutter - Quipubox

## 🏗️ PILARES DE LA ARQUITECTURA

- **Estructura feature-first:** Implementa cada funcionalidad dentro de `lib/features/<feature>/` y respeta las capas existentes: `data/`, `domain/` y `presentation/`. No muevas lógica de una capa a otra para atajar el patrón.
- **Flujo de dependencias:** Sigue estrictamente el flujo `ViewModel → UseCase → interfaz Repository → RepositoryImpl → DataSource → ApiClient`. El ViewModel NUNCA debe conectarse directamente a un datasource o repositorio concreto.
- **Inyección de dependencias (DI):** Cada feature registra sus dependencias en un módulo de `lib/app/di/modules/` mediante `static List<SingleChildWidget> get providers`. Registra en orden: `RemoteDataSource`, interfaz de repositorio vinculada a su implementación, use cases y `ChangeNotifierProvider` del ViewModel. Luego, agrega `...FeatureModule.providers` a `AppProviders.providers` en `lib/app/di/app_providers.dart`.

## 🌐 HTTP, ERRORES Y AUTENTICACIÓN

- **ApiClient:** Para toda llamada HTTP, SIEMPRE usa `ApiClient` (`get`, `post`, `put`, `patch` o `delete`) desde un `RemoteDataSource`. NUNCA importes ni llames `package:http` directamente. `ApiClient` construye la URL desde `AppConfig.baseUrl`, agrega headers JSON, omite valores `null` del body y añade `Authorization: Bearer <token>` cuando la sesión actual de Supabase tiene un access token.
- **Manejo de errores:** `ApiClient` convierte errores de conectividad, timeout y respuestas HTTP no exitosas en `AppException`. `ErrorMessageMapper.map` convierte excepciones en texto presentable. SIEMPRE deja que `BaseStateViewModel.run` o `runBool` maneje los errores de las operaciones asíncronas de los ViewModels; estos métodos asignan `errorMessage`, actualizan el estado y evitan ejecuciones duplicadas. No dupliques el mapeo ni muestres errores técnicos directamente en la UI.

## 🧠 VIEWMODELS Y GESTIÓN DE ESTADO

- **Herencia obligatoria:** NUNCA extiendas `ChangeNotifier` directamente. Los ViewModels de features que ejecutan operaciones de negocio SIEMPRE deben extender `BaseStateViewModel` (que hereda de `SafeChangeNotifier`). Usa `SafeChangeNotifier` directamente solo para ViewModels especializados (ej. Settings o conectividad). `SafeChangeNotifier` ignora `notifyListeners()` después de `dispose()`; no reemplaces esta protección por un `ChangeNotifier` normal.
- **Estado e interfaz:** Usa el estado y `errorMessage` expuestos por el ViewModel para actualizar la UI. No dupliques en widgets la gestión de carga, errores o bloqueo de operaciones que ya ofrece `BaseStateViewModel`.

## 📦 DATA, REPOSITORIES Y USECASES

- **Data:** El `RemoteDataSource` implementa el acceso remoto mediante `ApiClient` y convierte las respuestas JSON a modelos de `data/models/`. El repository concreto en `data/repositories/` implementa la interfaz abstracta de `domain/repositories/`, coordina el datasource y convierte modelos/request models a entidades de `domain/entities/`.
- **UseCases y lógica de negocio:** Cada operación de negocio debe exponerse mediante un use case en `domain/usecases/`, que depende de la interfaz del repository. 
  - **Inyección de `CurrentSession`:** Todo UseCase que cree o modifique datos DEBE inyectar `CurrentSession` en su constructor para obtener el `idEmpresa` del usuario autenticado. NUNCA pases el `idEmpresa` desde la UI o el ViewModel.
  - **Validaciones:** Las reglas de negocio (ej. "el cliente debe tener al menos una sede") se validan DENTRO del método `call()` del UseCase, lanzando `AppException` si no se cumplen.
  - **Enriquecimiento:** Usa `entity.copyWith(idEmpresa: idEmpresa)` para inyectar el ID de la empresa antes de llamar al repositorio.

## 🎨 PRESENTACIÓN Y UI

- **Reutilización de widgets:** NO crees widgets desde cero. Revisa primero los widgets existentes en `quipubox/lib/core/ui/` (como `AppCard`, `AppStatusBadge`, `EmptyState`, etc.) y reutilízalos. Si necesitas un widget nuevo, créalo siguiendo el mismo estilo y estructura que los existentes.
- **Referencias:** Para la lista de operaciones de carga, usa `AppCard` como base y sigue el patrón de `calidades_list_screen.dart` o `clientes_list_screen.dart`.

## ⚙️ ENTORNO Y CONFIGURACIÓN

- **API en Producción:** El proyecto es un sistema híbrido (Web y Móvil). La API está alojada en un host real y la versión web ya está en vivo. `AppConfig.baseUrl` DEBE apuntar siempre a la URL de producción. **NUNCA** sugieras cambiar la URL a `localhost` a menos que yo te lo pida explícitamente.
- **Seguridad del `.env`:** `.env` está declarado como un asset de Flutter incluido en el bundle y contiene configuración de cliente (URL/clave de Supabase, URL de redirección). NUNCA incluyas secretos del servidor en este archivo ni en el bundle de la aplicación.
- **SDK y comandos:** La restricción del SDK es `^3.11.4`. Desde `quipubox/`, usa `flutter pub get`, `flutter analyze`, `flutter test` y `flutter build apk`, según corresponda. Formatea siempre los archivos Dart modificados con `dart format <files>`.