import '../widgets/reparto_asignacion_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/cards/app_card_header.dart';
import '../../../../../core/ui/cards/app_card_info_grid.dart';
import '../../../../../core/ui/cards/app_card_info_row.dart';
import '../../../../../core/ui/feedback/delete_confirmation_dialog.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../../../core/network/connectivity_viewmodel.dart';
import '../../../carga/presentation/widgets/detalle_calidad_sheet.dart';
import '../../domain/entities/reparto.dart';
import '../viewmodels/reparto_detail_viewmodel.dart';
import '../widgets/asignacion_reparto_form.dart';
import '../widgets/reparto_linea_form.dart';

class RepartoDetailScreen extends StatelessWidget {
  final int operacionId;
  final int detalleId;
  const RepartoDetailScreen({
    super.key,
    required this.operacionId,
    required this.detalleId,
  });
  Future<void> _asignar(BuildContext context, {Reparto? editing}) async {
    final vm = context.read<RepartoDetailViewModel>();
    await AppBottomSheet.show<bool>(
      context: context,
      title: editing == null ? 'Asignar mercadería' : 'Editar asignación',
      minChildSize: .5,
      initialChildSize: .8,
      maxChildSize: .95,
      builder: (context, controller) => ChangeNotifierProvider.value(
        value: vm,
        child: AsignacionRepartoForm(controller: controller, editing: editing),
      ),
    );
  }

  Future<void> _linea(
    BuildContext context,
    Reparto item, {
    RepartoLinea? editing,
  }) async {
    final vm = context.read<RepartoDetailViewModel>();
    await AppBottomSheet.show<bool>(
      context: context,
      title: editing == null ? 'Completar desglose' : 'Editar calidad asignada',
      minChildSize: .4,
      initialChildSize: .6,
      maxChildSize: .85,
      builder: (context, controller) => ChangeNotifierProvider.value(
        value: vm,
        child: RepartoLineaForm(
          item: item,
          editing: editing,
          controller: controller,
        ),
      ),
    );
  }

  Future<void> _clasificar(BuildContext context) async {
    final vm = context.read<RepartoDetailViewModel>();
    final ok = await DetalleCalidadSheet.show(
      context: context,
      detalleId: detalleId,
      cantidadTotal: vm.data!.detalle.cantidadJabas,
    );
    if (ok == true) await vm.load(operacionId, detalleId);
  }

  Future<void> _delete(
    BuildContext context,
    Reparto item, {
    RepartoLinea? linea,
  }) async {
    final vm = context.read<RepartoDetailViewModel>();
    await DeleteConfirmationDialog.showAndAction(
      context: context,
      title: linea == null
          ? 'Eliminar asignación'
          : 'Eliminar calidad asignada',
      message: linea == null
          ? '¿Deseas eliminar la asignación a ${item.receptor?.nombreCompleto ?? 'este receptor'}?'
          : '¿Deseas quitar esta calidad de la asignación?',
      onConfirm: () => vm.remove(item.id, lineaId: linea?.id),
      getErrorMessage: () => vm.errorMessage,
      successMessage: 'Registro eliminado correctamente.',
      fallbackError: 'No se pudo eliminar el registro.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RepartoDetailViewModel>();
    final c = vm.data;
    final online = context.watch<ConnectivityViewModel>().isOnline;
    final canEdit = c != null && c.editable && !vm.isBusy && online;
    // La API actual vincula automáticamente toda calidad nueva al primer ítem
    // de reparto. No ejecutar ese flujo cuando ya se está distribuyendo.
    final clasificacionBloqueada =
        c != null &&
        (c.operacion.estado == 'repartiendo' ||
            (c.detalle.esReparto && c.repartos.isNotEmpty));
    return PopScope(
      canPop: !vm.isSaving && !vm.isDeleting,
      child: Scaffold(
        appBar: AppBar(title: Text('Reparto · carga #$detalleId')),
        body: SafeArea(
          top: false,
          child: c == null
              ? vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : EmptyState(
                        message:
                            vm.errorMessage ?? 'No se pudo cargar el reparto.',
                        actionLabel: 'Reintentar',
                        onAction: () => vm.load(operacionId, detalleId),
                      )
              : Column(
                  children: [
                    if (vm.isBusy) const LinearProgressIndicator(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => vm.load(operacionId, detalleId),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (vm.errorMessage != null)
                              EmptyState(
                                message: vm.errorMessage!,
                                actionLabel: 'Actualizar',
                                onAction: () => vm.load(operacionId, detalleId),
                              ),
                            AppCard(
                              header: AppCardHeader(
                                icon: const Icon(Icons.inventory_2_outlined),
                                title:
                                    '${c.detalle.cantidadJabas} jabas · ${c.detalle.fruta?.nombre ?? 'Fruta #${c.detalle.idFruta}'}${c.detalle.variedad == null ? '' : ' (${c.detalle.variedad!.nombre})'}',
                                subtitle:
                                    '${c.detalle.clienteEmisor?.nombreCompleto ?? 'Emisor #${c.detalle.idClienteEmisor}'} · ${c.detalle.esReparto ? 'Distribución posterior' : 'Entrega directa'}',
                              ),
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AppCardInfoGrid(
                                    children: [
                                      AppCardInfoRow(
                                        icon: Icons.category_outlined,
                                        label: 'Clasificadas',
                                        value:
                                            '${c.clasificadas}/${c.detalle.cantidadJabas}',
                                      ),
                                      AppCardInfoRow(
                                        icon: Icons.person_pin_outlined,
                                        label: 'Asignadas a destino',
                                        value:
                                            '${c.asignadas}/${c.detalle.cantidadJabas}',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (c.calidades.isEmpty)
                                    const Text(
                                      'Todavía no hay calidades registradas. Puedes clasificarlas desde aquí.',
                                    )
                                  else
                                    for (final q in c.calidades)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        child: Text(
                                          '${q.nombreCalidad ?? 'Calidad #${q.idCalidad}'}: ${q.cantidad} jabas · ${c.saldoCalidad(q.id ?? 0)} sin asignar por calidad',
                                        ),
                                      ),
                                  if (clasificacionBloqueada && c.editable)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'La clasificación en este estado o después de distribuir requiere el ajuste pendiente del servidor.',
                                      ),
                                    ),
                                  if (c.operacion.idSedeDestino == null)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Define la sede de destino en la operación de carga para seleccionar receptores y puestos.',
                                      ),
                                    ),
                                ],
                              ),
                              actions: Wrap(
                                alignment: WrapAlignment.end,
                                spacing: 8,
                                children: [
                                  if (c.editable)
                                    TextButton.icon(
                                      onPressed:
                                          canEdit && !clasificacionBloqueada
                                          ? () => _clasificar(context)
                                          : null,
                                      icon: const Icon(Icons.category_outlined),
                                      label: const Text('Clasificar carga'),
                                    ),
                                  if (c.editable &&
                                      (c.detalle.esReparto ||
                                          c.repartos.isEmpty))
                                    TextButton.icon(
                                      onPressed:
                                          canEdit &&
                                              c.asignadas <
                                                  c.detalle.cantidadJabas
                                          ? () => _asignar(context)
                                          : null,
                                      icon: const Icon(
                                        Icons.person_add_alt_rounded,
                                      ),
                                      label: const Text('Asignar receptor'),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Asignaciones (${c.repartos.length})',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            if (c.repartos.isEmpty)
                              const EmptyState(
                                message:
                                    'Esta carga aún no tiene destinatarios asignados.',
                              ),
                            for (final item in c.repartos)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: RepartoAsignacionCard(
                                  item: item,
                                  editable: c.editable,
                                  enabled: canEdit,
                                  canAddLinea:
                                      item.cantidadDesglosada < item.cantidad &&
                                      c.calidades.any(
                                        (q) =>
                                            !item.lineas.any(
                                              (l) => l.idCalidadCarga == q.id,
                                            ) &&
                                            c.saldoCalidad(q.id ?? 0) > 0,
                                      ),
                                  onEdit: () =>
                                      _asignar(context, editing: item),
                                  onDelete: () => _delete(context, item),
                                  onAddLinea: () => _linea(context, item),
                                  onEditLinea: (linea) =>
                                      _linea(context, item, editing: linea),
                                  onDeleteLinea: (linea) =>
                                      _delete(context, item, linea: linea),
                                ),
                              ),
                            if (!online)
                              const Text(
                                'Se requiere conexión para modificar los repartos.',
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
