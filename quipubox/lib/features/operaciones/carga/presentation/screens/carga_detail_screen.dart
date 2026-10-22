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
import '../widgets/detalle_carga_card.dart';

class CargaDetailScreen extends StatefulWidget {
  final int operationId;

  const CargaDetailScreen({super.key, required this.operationId});

  @override
  State<CargaDetailScreen> createState() => _CargaDetailScreenState();
}

class _CargaDetailScreenState extends State<CargaDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CargaViewModel>().loadById(widget.operationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CargaViewModel>();
    final operation = vm.selected?.id == widget.operationId
        ? vm.selected
        : null;

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
              onAction: () => vm.loadById(widget.operationId),
            ),
          );
        }

        return Column(
          children: [
            if (isBusy) const LinearProgressIndicator(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => vm.loadById(widget.operationId),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    _OperationSummary(operation: operation),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Detalles de carga',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Text('${vm.detalles.length}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (vm.detalles.isEmpty)
                      const EmptyState(
                        message: 'Esta operación aún no tiene detalles.',
                      )
                    else
                      ...vm.detalles.map(
                        (detalle) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DetalleCargaCard(item: detalle),
                        ),
                      ),
                    const SizedBox(height: 12),
                    _OperationActions(
                      operation: operation,
                      onStart: isBusy ? null : () => _changeEstado('en_curso'),
                      onFinalize: isBusy ? null : _finalizar,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }(),
    );
  }

  Future<void> _changeEstado(String estado) async {
    final vm = context.read<CargaViewModel>();
    final succeeded = await vm.changeEstado(
      id: widget.operationId,
      estado: estado,
    );
    if (!mounted) return;
    AppToast.show(
      succeeded
          ? 'La operación pasó a estado en curso.'
          : vm.errorMessage ?? 'No se pudo cambiar el estado.',
      type: succeeded ? ToastType.success : ToastType.error,
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

class _OperationActions extends StatelessWidget {
  final OperacionCarga operation;
  final VoidCallback? onStart;
  final VoidCallback? onFinalize;

  const _OperationActions({
    required this.operation,
    required this.onStart,
    required this.onFinalize,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (operation.estado == 'pendiente')
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Iniciar carga'),
          ),
        if (operation.estado == 'en_curso')
          FilledButton.icon(
            onPressed: onFinalize,
            icon: const Icon(Icons.task_alt_rounded),
            label: const Text('Finalizar carga'),
          ),
      ],
    );
  }
}
