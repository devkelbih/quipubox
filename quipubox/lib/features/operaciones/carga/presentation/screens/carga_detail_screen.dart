import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_grid.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/feedback/app_toast.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/states/empty_state.dart';

import '../../domain/entities/operacion_carga.dart';
import '../viewmodels/carga_viewmodel.dart';
import '../widgets/estado_operacion_carga_ui.dart';
import '../../domain/entities/detalle_carga.dart';

class CargaDetailScreen extends StatefulWidget {
  final int operationId;
  final OperacionCarga? operation;

  const CargaDetailScreen({
    super.key,
    required this.operationId,
    this.operation,
  });

  @override
  State<CargaDetailScreen> createState() => _CargaDetailScreenState();
}

class _CargaDetailScreenState extends State<CargaDetailScreen> {
  Future<void> _loadDetails() async {
    if (!mounted) return;
    final vm = context.read<CargaViewModel>();
    final cached = vm.selected?.id == widget.operationId ? vm.selected : null;
    final operation =
        cached ??
        widget.operation ??
        vm.items.where((item) => item.id == widget.operationId).firstOrNull;
    if (operation != null && operation.id == widget.operationId) {
      await vm.loadDetalles(operation);
    } else {
      // Respaldo para enlaces directos sin cabecera en memoria.
      await vm.loadById(widget.operationId);
    }
  }

  void _addDetalle() {
    // TODO: Abrir el formulario de registro de detalle de carga y refrescar solo los detalles al guardar.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'El registro de ítems de carga estará disponible próximamente.',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetails());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CargaViewModel>();
    final operation = vm.selected?.id == widget.operationId
        ? vm.selected
        : widget.operation;

    final isBusy = vm.isSaving || vm.isChangingStatus || vm.isDeleting;

    return Scaffold(
      appBar: AppBar(
        title: Text('Operación #${widget.operationId}'),
        actions: [
          if (operation != null && operation.estado == 'pendiente')
            IconButton(
              tooltip: 'Eliminar operación',
              onPressed: isBusy ? null : _confirmDelete,
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            ),
        ],
      ),
      body: () {
        if (vm.isLoading && operation == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (operation == null) {
          return Center(
            child: EmptyState(
              message: vm.errorMessage ?? 'No se encontró la operación.',
              actionLabel: 'Reintentar',
              onAction: _loadDetails,
            ),
          );
        }

        final canModify = const [
          'pendiente',
          'en_curso',
          'en_transito',
        ].contains(operation.estado);
        return Column(
          children: [
            if (isBusy || vm.isLoading) const LinearProgressIndicator(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadDetails,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.detalles.length + 3,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _OperationSummary(operation: operation);
                    }
                    if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Detalles de carga (${vm.detalles.length})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                if (canModify)
                                  TextButton.icon(
                                    onPressed: isBusy || vm.isLoading
                                        ? null
                                        : _addDetalle,
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Agregar'),
                                  ),
                              ],
                            ),
                            if (vm.errorMessage != null)
                              EmptyState(
                                message: vm.errorMessage!,
                                actionLabel: 'Reintentar',
                                onAction: _loadDetails,
                              )
                            else if (!vm.isLoading && vm.detalles.isEmpty)
                              const EmptyState(
                                message:
                                    'Esta operación aún no tiene detalles.',
                              ),
                          ],
                        ),
                      );
                    }
                    if (index == vm.detalles.length + 2) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: canModify
                            ? FilledButton.icon(
                                onPressed:
                                    isBusy ||
                                        vm.isLoading ||
                                        vm.errorMessage != null ||
                                        vm.detalles.isEmpty
                                    ? null
                                    : _finalizar,
                                icon: const Icon(Icons.task_alt_rounded),
                                label: const Text('Finalizar operación'),
                              )
                            : const SizedBox.shrink(),
                      );
                    }
                    return _DetalleCargaRow(item: vm.detalles[index - 2]);
                  },
                ),
              ),
            ),
          ],
        );
      }(),
    );
  }

  Future<void> _finalizar() async {
    final vm = context.read<CargaViewModel>();
    final succeeded = await vm.finalizar(widget.operationId);
    if (!mounted) return;
    AppToast.show(
      succeeded
          ? 'Operación finalizada y enviada a reparto.'
          : vm.errorMessage ?? 'No se pudo finalizar la operación.',
      type: succeeded ? ToastType.success : ToastType.error,
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar operación'),
        content: const Text('¿Deseas eliminar esta operación de carga?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final vm = context.read<CargaViewModel>();
    final succeeded = await vm.eliminar(widget.operationId);
    if (!mounted) return;
    if (succeeded) {
      context.pop();
    } else {
      AppToast.show(
        vm.errorMessage ?? 'No se pudo eliminar la operación.',
        type: ToastType.error,
      );
    }
  }
}

class _OperationSummary extends StatelessWidget {
  final OperacionCarga operation;

  const _OperationSummary({required this.operation});

  @override
  Widget build(BuildContext context) {
    final status = operation.estadoEnum.status;
    final nombreOrigen =
        operation.sedeOrigen?.nombre ?? 'Sede #${operation.idSedeOrigen}';
    final nombreDestino = operation.idSedeDestino != null
        ? (operation.sedeDestino?.nombre ?? 'Sede #${operation.idSedeDestino}')
        : 'Sin destino';
    final placaCamion =
        operation.camion?.placa ?? 'Camión #${operation.idCamion}';
    final nombreEncargado = operation.encargadoCarga != null
        ? '${operation.encargadoCarga!.nombres} ${operation.encargadoCarga!.apellidos ?? ''}'
              .trim()
        : 'Usuario #${operation.idEncargadoCarga}';
    final nombreRepartidor = operation.repartidorAsignado != null
        ? '${operation.repartidorAsignado!.nombres} ${operation.repartidorAsignado!.apellidos ?? ''}'
              .trim()
        : 'Usuario #${operation.idRepartidorAsignado}';

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.local_shipping_rounded),
        title: '$nombreOrigen → $nombreDestino',
        subtitle:
            '${_dateText(operation.fechaCarga)} ${operation.horaCarga ?? ''}'
                .trim(),
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoGrid(
              children: [
                AppCardInfoRow(
                  icon: Icons.local_shipping_outlined,
                  label: 'Camión',
                  value: placaCamion,
                ),
                if (operation.idEncargadoCarga != null) ...[
                  AppCardInfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Encargado',
                    value: nombreEncargado,
                  ),
                ],
              ],
            ),

            if (operation.idRepartidorAsignado != null) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.delivery_dining_rounded,
                label: 'Repartidor',
                value: nombreRepartidor,
              ),
            ],

            if (operation.observaciones?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Observaciones',
                value: operation.observaciones!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _dateText(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _DetalleCargaRow extends StatelessWidget {
  final DetalleCarga item;
  const _DetalleCargaRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final fruta = item.fruta?.nombre ?? 'Fruta #${item.idFruta}';
    final tipoJaba = item.tipoJaba?.nombre ?? 'Tipo #${item.idTipoJaba}';
    final emisor =
        item.clienteEmisor?.nombreCompleto ??
        'Cliente #${item.idClienteEmisor}';
    final receptor = item.clientesReceptores.isEmpty
        ? 'Sin asignar'
        : item.clientesReceptores.join(', ');
    final calidades = item.calidades.isEmpty
        ? 'Sin registrar'
        : item.calidades.join(', ');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Text(
            '${item.cantidadJabas}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          title: Text('$fruta · $tipoJaba'),
          subtitle: Text(
            'Jabas · Calidad: $calidades\nEmisor: $emisor\nReceptor: $receptor',
          ),
          isThreeLine: true,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
