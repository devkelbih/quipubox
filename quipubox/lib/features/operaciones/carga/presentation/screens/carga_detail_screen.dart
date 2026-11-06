import '../../domain/entities/detalle_carga_calidad.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/ui/feedback/app_toast.dart';
import '../../../../../core/ui/feedback/delete_confirmation_dialog.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../domain/entities/operacion_carga.dart';
import '../../domain/entities/detalle_carga.dart';
import '../viewmodels/carga_viewmodel.dart';
import '../widgets/carga_details_list.dart';
import '../widgets/detalle_calidad_sheet.dart';

class CargaDetailScreen extends StatefulWidget {
  final int operationId;
  final OperacionCarga? operation;
  final bool openDetalleForm;

  const CargaDetailScreen({
    super.key,
    required this.operationId,
    this.operation,
    this.openDetalleForm = false,
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

  Future<void> _addDetalle() async {
    final saved = await context.push<bool>(
      AppRoutes.detalleCargaCreatePath(widget.operationId),
    );
    if (saved == true && mounted) {
      // Crear la primera carga también cambia el estado del encabezado en la API.
      await context.read<CargaViewModel>().loadById(widget.operationId);
    }
  }

  Future<void> _editDetalle(DetalleCarga detalle) async {
    final saved = await context.push<bool>(
      '${AppRoutes.operacionCargaDetailPath(widget.operationId)}/detalles/${detalle.id}/edit',
      extra: detalle,
    );
    if (saved == true && mounted) {
      await context.read<CargaViewModel>().loadById(widget.operationId);
    }
  }

  Future<void> _addCalidad(
    DetalleCarga detalle, {
    DetalleCargaCalidad? editing,
  }) async {
    final id = detalle.id;
    if (id == null) return;
    final saved = await DetalleCalidadSheet.show(
      context: context,
      detalleId: id,
      editing: editing,
      cantidadTotal: detalle.cantidadJabas,
    );
    if (saved == true && mounted) await _loadDetails();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDetails();
      if (!mounted || !widget.openDetalleForm) return;
      await _addDetalle();
    });
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
            PopupMenuButton<String>(
              enabled: !isBusy,
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'delete') {
                  _confirmDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Eliminar operación',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: () {
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

          return CargaDetailsList(
            operation: operation,
            detalles: vm.detalles,
            isBusy: isBusy,
            isLoading: vm.isLoading,
            errorMessage: vm.errorMessage,
            onRefresh: _loadDetails,
            onAddDetalle: _addDetalle,
            onFinalizar: _finalizar,
            onAddCalidad: _addCalidad,
            onEditDetalle: _editDetalle,
            onEditCalidad: (detalle, calidad) =>
                _addCalidad(detalle, editing: calidad),
            onDeleteDetalle: _deleteDetalle,
          );
        }(),
      ),
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

  Future<void> _deleteDetalle(DetalleCarga detalle) async {
    final id = detalle.id;
    if (id == null) return;
    final vm = context.read<CargaViewModel>();
    await DeleteConfirmationDialog.showAndAction(
      context: context,
      title: 'Eliminar detalle',
      message:
          '¿Deseas eliminar este item de ${detalle.cantidadJabas} jabas que envía ${detalle.clienteEmisor?.nombreCompleto ?? 'Cliente #${detalle.idClienteEmisor}'}?\n'
          'Esta acción no se puede deshacer.',
      onConfirm: () =>
          vm.eliminarDetalle(operacionId: widget.operationId, detalleId: id),
      getErrorMessage: () => vm.errorMessage,
      successMessage: 'Detalle eliminado correctamente.',
      fallbackError: 'No se pudo eliminar el detalle.',
    );
  }

  Future<void> _confirmDelete() async {
    final vm = context.read<CargaViewModel>();
    final operation = vm.selected?.id == widget.operationId
        ? vm.selected
        : widget.operation;
    if (operation == null) return;
    final origen =
        operation.sedeOrigen?.nombre ?? 'Sede #${operation.idSedeOrigen}';
    final destino =
        operation.sedeDestino?.nombre ??
        (operation.idSedeDestino == null
            ? 'sin destino asignado'
            : 'Sede #${operation.idSedeDestino}');
    final deleted = await DeleteConfirmationDialog.showAndAction(
      context: context,
      title: 'Eliminar operación',
      message:
          '¿Deseas eliminar esta operación de carga con sentido $origen → $destino?',
      onConfirm: () => vm.eliminar(widget.operationId),
      getErrorMessage: () => vm.errorMessage,
      successMessage: 'Operación eliminada correctamente.',
      fallbackError: 'No se pudo eliminar la operación.',
    );
    if (deleted && mounted) context.pop();
  }
}
