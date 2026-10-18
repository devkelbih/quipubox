# Guía del espacio de trabajo

Este espacio de trabajo contiene dos aplicaciones independientes. Ejecuta los comandos desde la raíz del proyecto correspondiente y sigue sus instrucciones específicas:

- [Instrucciones de API](.github/instructions/api-qb.instructions.md) para `api-qb/`.
- [Instrucciones de Flutter](.github/instructions/quipubox.instructions.md) para `quipubox/`.

Rol del Desarrollador: El usuario actual se encarga EXCLUSIVAMENTE de la aplicación Flutter (quipubox/). La carpeta api-qb/ pertenece a otro desarrollador y es de SOLO LECTURA. Puedes leerla para entender los endpoints y los DTOs, pero NUNCA modifiques archivos dentro de api-qb/. Si un DTO de la API cambia, tu trabajo es adaptar el código de Flutter para que coincida con lo que provee la API.