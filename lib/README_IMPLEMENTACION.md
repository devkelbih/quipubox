# Quipubox - lib base

Esta carpeta `lib/` contiene una base funcional para Quipubox con:

- Clean Architecture + Provider + Feature First + MVVM.
- Login exclusivo con Google mediante Supabase.
- Router centralizado con GoRouter.
- Theme centralizado para modo claro/oscuro.
- Drawer modular.
- Dashboard inicial.
- CRUD genérico para módulos ya disponibles en la API.
- Estados `isLoading`, `isSaving`, `isDeleting`.
- Toasts reutilizables.
- Banner de conexión sin internet.
- Empresa actual asumida: `id_empresa = 1`.

## Dependencias que debes agregar

```yaml
dependencies:
  http: ^1.2.2
  shared_preferences: ^2.3.3
```

Ya tienes:
- provider
- supabase_flutter
- flutter_dotenv
- go_router
- equatable
- intl

## Permisos Android recomendados

En `AndroidManifest.xml` ya tienes internet. Cuando agregues cámara/galería real:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

Para Android 12 o menor podrías necesitar:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
```

## Nota

Los módulos de operaciones, reparto, control de jabas, evidencias, incidencias y reportes quedan visibles en el drawer, pero muestran toast porque no incluiste endpoints para ellos todavía.
