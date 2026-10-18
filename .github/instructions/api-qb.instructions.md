---
description: "Usa estas instrucciones al modificar la API de NestJS, el esquema o las migraciones de Prisma, las pruebas del backend o la configuración de la API."
applyTo: "api-qb/**"
---
# Guía de la API

- Las funcionalidades de negocio están en `src/modules/`; mantén el mapeo HTTP en los controllers y la lógica de negocio en los services. Sigue los patrones de DTO y `class-validator` del módulo más cercano. La infraestructura compartida corresponde a `src/common/` o `src/config/`.
- Antes de cambiar la persistencia o los contratos de API, revisa [el esquema de Prisma](../../api-qb/prisma/schema.prisma) y cómo lo usan los módulos cercanos. Mantén los campos de los modelos de Prisma y la serialización de DTO coherentes con las convenciones existentes.
- Las conexiones en tiempo de ejecución usan `DATABASE_URL`; las operaciones de Prisma CLI usan `DIRECT_URL` desde `prisma.config.ts`. Actualmente, el repositorio no tiene historial de migraciones. Antes de crear o aplicar migraciones, comprueba la base de datos de destino y el estado inicial de las migraciones; no supongas que está vacía.
- `ENABLE_AUTH` controla el guard de Supabase. Si está desactivado, el guard omite la validación del token y asigna una identidad de prueba; nunca trates ese modo como autenticación de producción.
- Desde `api-qb/`, usa `npm ci`, `npm run build`, `npm test` o `npm run test:e2e`, según corresponda. Ejecuta `npx prisma generate` después de cambiar el esquema o el cliente. `npm run lint` incluye ESLint `--fix` y modifica archivos; ejecútalo deliberadamente.
- Al depurar la integración local, consulta `src/main.ts` para comprobar el puerto y los valores predeterminados de CORS. No incluyas secretos de entorno en commits.