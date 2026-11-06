import '../../domain/entities/detalle_carga_calidad.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/detalle_carga.dart';
import 'detalle_carga_info_sheet.dart';

class DetalleCargaRow extends StatelessWidget {
  final DetalleCarga item;
  final VoidCallback? onAddCalidad;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final ValueChanged<DetalleCargaCalidad>? onEditCalidad;
  final Widget? dragHandle;
  const DetalleCargaRow({
    super.key,
    required this.item,
    this.onAddCalidad,
    this.onDelete,
    this.onEdit,
    this.onEditCalidad,
    this.dragHandle,
  });

  Future<void> _openInfo(BuildContext context) => DetalleCargaInfoSheet.show(
    context: context,
    item: item,
    onAddCalidad: onAddCalidad,
    onEditCalidad: onEditCalidad,
    minChildSize: .50,
    initialChildSize: .55,
    maxChildSize: .60,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clasificadas = item.cantidadClasificada;
    final sinCalidades =
        clasificadas == 0 || (clasificadas == null && item.calidades.isEmpty);
    final completa =
        item.cantidadJabas > 0 && clasificadas == item.cantidadJabas;
    final exceso = clasificadas != null && clasificadas > item.cantidadJabas;
    final statusColor = sinCalidades || exceso
        ? theme.colorScheme.error
        : completa
        ? AppColors.success
        : AppColors.warning;
    final statusIcon = sinCalidades || exceso
        ? Icons.error_outline_rounded
        : completa
        ? Icons.check_circle_outline_rounded
        : Icons.timelapse_rounded;
    final statusText = sinCalidades
        ? 'Sin calidades registradas'
        : exceso
        ? 'Revisar: $clasificadas clasificadas de ${item.cantidadJabas} jabas'
        : completa
        ? 'Clasificación completa: $clasificadas de ${item.cantidadJabas} jabas'
        : clasificadas == null
        ? 'Calidades registradas: cantidad pendiente de verificar'
        : 'Clasificación parcial: $clasificadas de ${item.cantidadJabas} jabas';
    final fruta = item.fruta?.nombre ?? 'Fruta #${item.idFruta}';
    final variedad = item.variedad?.nombre.trim() ?? '';
    final tipoJaba = item.tipoJaba?.nombre ?? 'Tipo #${item.idTipoJaba}';

    final calidades = item.calidades
        .map((nombre) => nombre.trim())
        .where((nombre) => nombre.isNotEmpty)
        .join(', ');

    final emisor = item.clienteEmisor?.nombreCompleto.trim();
    final receptor = item.clienteReceptor?.nombreCompleto.trim();

    final nombreEmisor = emisor?.isNotEmpty == true ? emisor! : 'No asignado';

    final destino = receptor?.isNotEmpty == true ? 'R: $receptor' : 'Reparto';

    final frutaConVariedad = variedad.isNotEmpty ? '$fruta ($variedad)' : fruta;

    final clasificacion = sinCalidades
        ? 'Sin clasificar'
        : exceso
        ? 'Revisar clasificación'
        : clasificadas != null && !completa
        ? 'Faltan ${item.cantidadJabas - clasificadas} de ${item.cantidadJabas}'
        : calidades.isNotEmpty
        ? calidades
        : 'Clasificación completa';
    final primeraLinea = '$frutaConVariedad - $clasificacion';

    final segundaLinea = 'E: $nombreEmisor - $destino';

    Widget menuLabel(IconData icon, String text, {bool destructive = false}) {
      final color = destructive
          ? theme.colorScheme.error.withValues(alpha: onDelete == null ? .5 : 1)
          : null;
      return Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: color)),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minVerticalPadding: 10,
          horizontalTitleGap: 10,
          titleAlignment: ListTileTitleAlignment.center,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dragHandle != null)
                dragHandle!
              else
                Tooltip(
                  message: statusText,
                  child: Icon(statusIcon, size: 20, color: statusColor),
                ),
              const SizedBox(width: 2),
              Semantics(
                label:
                    '${item.cantidadJabas} jabas, tipo $tipoJaba. $statusText',
                excludeSemantics: true,
                child: SizedBox(
                  width: 76,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${item.cantidadJabas}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Tooltip(
                        message: tipoJaba,
                        child: Text(
                          tipoJaba,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          title: Tooltip(
            message: primeraLinea,
            child: Text(
              primeraLinea,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: segundaLinea,
                  child: Text(
                    segundaLinea,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message:
                    'Requiere retorno de jabas: ${item.requiereRetornoJabas ? 'Sí' : 'No'}',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment_return_outlined,
                      size: 14,
                      color: item.requiereRetornoJabas
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      item.requiereRetornoJabas ? 'Sí' : 'No',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: dragHandle != null
              ? null
              : PopupMenuButton<String>(
                  tooltip: 'Opciones de carga',
                  icon: const Icon(Icons.more_vert_rounded),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  onSelected: (action) {
                    if (action == 'ver') {
                      _openInfo(context);
                    }
                    if (action == 'calidad') onAddCalidad?.call();
                    if (action == 'editar') onEdit?.call();
                    if (action == 'eliminar') onDelete?.call();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'ver',
                      child: menuLabel(
                        Icons.visibility_outlined,
                        'Ver detalle',
                      ),
                    ),

                    PopupMenuItem(
                      value: 'editar',
                      enabled: onEdit != null,
                      child: menuLabel(Icons.edit_outlined, 'Editar detalle'),
                    ),
                    PopupMenuItem(
                      value: 'calidad',
                      enabled: onAddCalidad != null,
                      child: menuLabel(
                        Icons.add_circle_outline,
                        'Agregar calidad',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'eliminar',
                      enabled: onDelete != null,
                      child: menuLabel(
                        Icons.delete_outline,
                        'Eliminar detalle',
                        destructive: true,
                      ),
                    ),
                  ],
                ),
          onTap: dragHandle != null ? null : () => _openInfo(context),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
