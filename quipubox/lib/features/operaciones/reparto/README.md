# Repartos

Entrada: drawer → Operaciones → Repartos (`/operaciones/reparto`).
Operación: `/operaciones/reparto/:operationId`.
Detalle de carga: `/operaciones/reparto/:operationId/cargas/:detailId`.

## Flujo

- Listado inicial de operaciones en cards: placa, ruta, fecha y estado. Búsqueda local con 350 ms y filtros de fecha/estado. Solo consulta cabeceras; no descarga detalles ni asignaciones de todos los viajes para inventar métricas.
- Pantalla independiente de distribución por operación, con jabas cargadas, número de cargas, frutas distintas y barras separadas de destinatarios definidos y calidades registradas.
- Dentro de la operación: vistas Cargas / Asignaciones, búsqueda propia y filtros de cargas sin destinatario, asignación parcial o calidades incompletas.
- Los faltantes se calculan por carga para que un exceso no compense los pendientes de otra. Las cantidades de calidad omitidas se muestran como Por verificar. Una asignación directa completa puede tener el desglose por calidad incompleto.
- Se consultan todos los detalles de la operación, incluidos los que no tienen calidades. No se depende de los endpoints de pendientes, que excluyen esos registros.
- Clasificación mediante el formulario compartido de carga.
- Asignación simple (reserva sin desglose), por calidades a un receptor, o varios receptores preparados y enviados juntos.
- Las entregas directas completan el desglose del ítem existente. No se crea otra asignación si ya existe.
- Edición de destino, cantidad, orden y observaciones de una asignación; mantenimiento de sus líneas de calidad y precio opcional.
- No se registran entregas físicas: asignar mercadería no acredita su recepción.

## Arquitectura y consultas

ViewModel → UseCase → RepartoRepository → implementación → datasource → ApiClient.
Las mutaciones validan sesión, estado, pertenencia, receptor/puesto/sección, cantidades y saldos. La empresa se obtiene de CurrentSession; los DTO actuales no aceptan id_empresa en el JSON.
Antes de guardar se vuelve a consultar el contexto para validar con saldos recientes. Esto no sustituye las validaciones transaccionales del servidor.

Se cubren GET/POST/PUT/DELETE de `/items-reparto`, `from-calidades`, `from-calidades-multiple`, consultas por detalle de carga y mantenimiento de `/items-reparto/:id/detalle` y `/items-reparto/detalle/:id`.

## Pendientes del backend

- Alinear cerrar carga → en_transito. Actualmente finalizar marca repartiendo y el servicio de calidades bloquea crear/editar en ese estado. La pantalla informa ese límite y deshabilita clasificar en repartiendo; Flutter no cambia el estado para evitar ese bloqueo.
- Corregir la vinculación automática de calidades al primer ítem y su condición es_reparto; una entrega directa puede quedar sin desglose y una distribución puede vincular cantidades de manera no deseada. Por esa razón se deshabilita clasificar una carga de distribución que ya tenga asignaciones. Esto es una limitación temporal, no la regla de negocio deseada.
- Ofrecer una mutación transaccional para modificar asignación y desglose juntos. Actualmente agregar/editar/eliminar una línea no recalcula cantidad_asignada. La UI muestra explícitamente cuánto falta desglosar, valida que no se exceda el encabezado y permite corregirlo por separado. No intenta dos escrituras con rollback aparente.
- Eliminar asignaciones con líneas requiere revisar la política transaccional/cascada. Flutter pide eliminar sus líneas primero y protege registros con entregas o guía emitida.
- Paginar y filtrar asignaciones por operación y clientes por sede. Se usa /clientes/all temporalmente. El catálogo de puestos completa la relación lugar/sede omitida por esa consulta.
- Garantizar aislamiento por empresa y saldos bajo concurrencia en el backend. No se modifican los archivos de api-qb.

## Validación

Pruebas locales en `test/features/operaciones/reparto`: contratos y serialización, límites de calidad y encabezado, duplicados, asignaciones múltiples, entrega directa, mutaciones y flujo visual en tema claro/oscuro. No escriben en la API de producción.
