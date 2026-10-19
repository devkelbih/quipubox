import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/feedback/app_toast.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/states/empty_state.dart';

import '../../../../../core/navigation/app_routes.dart';
import '../../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../domain/entities/operacion_carga.dart';
import '../viewmodels/carga_viewmodel.dart';
import '../widgets/carga_card.dart';
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

    return AppScaffold.withTextTitle(
      title: 'Operación #${widget.operationId}',
      actions: [
        IconButton(
          tooltip: 'Volver',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        if (operation != null && operation.estado != 'cancelada')
          IconButton(
            tooltip: 'Editar operación',
            onPressed: () => context.push(
              AppRoutes.operacionCargaEditPath(widget.operationId),
              extra: operation,
            ),
            icon: const Icon(Icons.edit_rounded),
          ),
      ],
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
            if (vm.isSaving || vm.isChangingStatus)
              const LinearProgressIndicator(),
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
                      onStart: () => _changeEstado('en_curso'),
                      onFinalize: _finalizar,
                      onCancel: () => _confirmCancel(operation),
                      onGenerateGuides: _generateGuides,
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

  Future<void> _generateGuides() async {
    final vm = context.read<CargaViewModel>();
    final succeeded = await vm.generarGuias(widget.operationId);
    if (!mounted) return;
    AppToast.show(
      succeeded
          ? 'Guías generadas correctamente.'
          : vm.errorMessage ?? 'No se pudieron generar las guías.',
      type: succeeded ? ToastType.success : ToastType.error,
    );
  }

  Future<void> _confirmCancel(OperacionCarga operation) async {
    final vm = context.read<CargaViewModel>();
    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: true,
      article: 'La',
      entityName: 'operación de carga',
      itemName: '#${widget.operationId}',
      actionLabel: 'Cancelar',
      successMessageOverride: 'Operación de carga cancelada correctamente.',
      fallbackErrorOverride: 'No se pudo cancelar la operación de carga.',
      onConfirm: (newStatus) async =>
          newStatus ? false : vm.cancelar(widget.operationId),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}

class _OperationSummary extends StatelessWidget {
  final OperacionCarga operation;

  const _OperationSummary({required this.operation});

  @override
  Widget build(BuildContext context) {
    final status = CargaCard.statusFor(operation.estado);

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.local_shipping_rounded),
        title: 'Operación #${operation.id}',
        subtitle: _dateText(operation.fechaCarga),
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.trip_origin_rounded,
              label: 'Sede de origen',
              value: 'Sede #${operation.idSedeOrigen}',
            ),
            if (operation.idSedeDestino != null) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.place_outlined,
                label: 'Sede de destino',
                value: 'Sede #${operation.idSedeDestino}',
              ),
            ],
            const SizedBox(height: 8),
            AppCardInfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Camión',
              value: 'Camión #${operation.idCamion}',
            ),
            if (operation.idEncargadoCarga != null) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.person_outline_rounded,
                label: 'Encargado',
                value: 'Usuario #${operation.idEncargadoCarga}',
              ),
            ],
            if (operation.idRepartidorAsignado != null) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.delivery_dining_rounded,
                label: 'Repartidor',
                value: 'Usuario #${operation.idRepartidorAsignado}',
              ),
            ],
            if (operation.horaCarga != null) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.schedule_rounded,
                label: 'Hora de carga',
                value: operation.horaCarga!,
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
  final VoidCallback onStart;
  final VoidCallback onFinalize;
  final VoidCallback onCancel;
  final VoidCallback onGenerateGuides;

  const _OperationActions({
    required this.operation,
    required this.onStart,
    required this.onFinalize,
    required this.onCancel,
    required this.onGenerateGuides,
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
        if (operation.estado == 'repartiendo')
          FilledButton.tonalIcon(
            onPressed: onGenerateGuides,
            icon: const Icon(Icons.description_outlined),
            label: const Text('Generar guías'),
          ),
        if (operation.estado != 'repartiendo' &&
            operation.estado != 'cancelada')
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancelar operación'),
          ),
      ],
    );
  }
}
