---
description: "Usa estas instrucciones al modificar la aplicación Flutter, funcionalidades de Dart, navegación, gestión de estado, networking o configuración móvil."
applyTo: "quipubox/**"
---
# Guía de Flutter

- Sigue la estructura feature-first de `lib/features/` y usa las capas data/domain/presentation existentes cuando estén presentes. Registra los providers de funcionalidades en `lib/app/di/` y las rutas en `lib/core/navigation/app_router.dart`, en lugar de añadir wiring paralelo.
- Reutiliza `ApiClient` para las llamadas HTTP y la gestión de tokens de Supabase. Mantén alineados los campos de solicitud y respuesta con los DTO de la API. Sigue los patrones existentes de repository, use-case y `ChangeNotifier` de la funcionalidad.

- Contexto de Entorno: El proyecto es un sistema híbrido (Web y Móvil). La API está alojada en un host real de producción y la versión web ya está en vivo. Por lo tanto, AppConfig.baseUrl DEBE apuntar siempre a la URL de producción. No sugieras ni cambies la URL a localhost a menos que yo te lo pida explícitamente para una prueba muy específica.

- `.env` está declarado como un asset de Flutter incluido en el bundle y contiene configuración de cliente, como la URL/clave de Supabase y la URL de redirección. Nunca incluyas secretos del servidor en este archivo ni en el bundle de la aplicación.
- La restricción del SDK es `^3.11.4`. Desde `quipubox/`, usa `flutter pub get`, `flutter analyze`, `flutter test` y `flutter build apk`, según corresponda; formatea los archivos Dart modificados con `dart format <files>`.