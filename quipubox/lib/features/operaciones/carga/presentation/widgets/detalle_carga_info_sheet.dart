import '../../domain/entities/detalle_carga_calidad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/ui/cards/app_card_info_row.dart';
import '../../../../../core/ui/cards/app_card_info_grid.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../domain/entities/detalle_carga.dart';
import '../viewmodels/detalle_calidad_viewmodel.dart';

class DetalleCargaInfoSheet {
  const DetalleCargaInfoSheet._();

  static Future<void> show({
    required BuildContext context,
    required DetalleCarga item,
    VoidCallback? onAddCalidad,
    ValueChanged<DetalleCargaCalidad>? onEditCalidad,
    double minChildSize = .2,
    double initialChildSize = .7,
    double maxChildSize = .7,
  }) async {
    final fruta = item.fruta?.nombre ?? 'Fruta #${item.idFruta}';
    final variedad = item.variedad?.nombre.trim() ?? '';
    final frutaConVariedad = variedad.isEmpty ? fruta : '$fruta ($variedad)';
    final tipoJaba = item.tipoJaba?.nombre ?? 'Tipo #${item.idTipoJaba}';
    final cliente = item.clienteEmisor;
    final nombreCompleto = cliente?.nombreCompleto.trim();
    final emisor = nombreCompleto?.isNotEmpty == true
        ? nombreCompleto!
        : 'Cliente #${item.idClienteEmisor}';
    final calidades = item.calidades
        .map((nombre) => nombre.trim())
        .where((nombre) => nombre.isNotEmpty)
        .join(', ');

    // Cantidad, fruta y variedad identifican la carga en la cabecera.
    final rows = <(IconData, String, String)>[
      (Icons.person_outline_rounded, 'Emisor', emisor),
      (
        Icons.route_outlined,
        'Modalidad',
        item.esReparto ? 'Reparto' : 'Entrega directa',
      ),
      if (!item.esReparto)
        (
          Icons.person_pin_outlined,
          'Receptor',
          item.clienteReceptor?.nombreCompleto ?? 'No asignado',
        ),
      (
        Icons.assignment_return_outlined,
        'Retorno de jabas',
        item.requiereRetornoJabas ? 'Sí' : 'No',
      ),
      (Icons.inventory_outlined, 'Tipo de jaba', tipoJaba),
    ];
    // Textos largos -> ancho completo, fuera del grid.
    final fullWidthRows = <(IconData, String, String)>[
      if (item.instruccionReparto?.trim().isNotEmpty == true)
        (Icons.description_outlined, 'Instrucciones', item.instruccionReparto!),
      if (item.observaciones?.trim().isNotEmpty == true)
        (Icons.notes_rounded, 'Observaciones', item.observaciones!),
    ];

    final addCalidad = await AppBottomSheet.show<Object>(
      context: context,
      title: '${item.cantidadJabas} jabas · $frutaConVariedad',
      minChildSize: minChildSize,
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      builder: (sheetContext, scrollController) {
        final content = Builder(
          builder: (context) {
            final vm = item.id == null
                ? null
                : context.watch<DetalleCalidadViewModel>();
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                AppCardInfoGrid(
                  children: [
                    for (final row in rows)
                      AppCardInfoRow(
                        icon: row.$1,
                        label: row.$2,
                        value: row.$3,
                      ),
                  ],
                ),
                for (final row in fullWidthRows)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: AppCardInfoRow(
                      icon: row.$1,
                      label: row.$2,
                      value: row.$3,
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Calidades',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (vm == null)
                  Text(
                    calidades.isEmpty
                        ? 'Sin calidades registradas.'
                        : calidades,
                  )
                else if (vm.isLoading || !vm.loaded && vm.errorMessage == null)
                  const Center(child: CircularProgressIndicator())
                else if (!vm.loaded)
                  EmptyState(
                    message:
                        vm.errorMessage ??
                        'No se pudieron cargar las calidades.',
                    actionLabel: 'Reintentar',
                    onAction: () => vm.loadRegistradas(item.id!),
                  )
                else if (vm.registradas.isEmpty)
                  const Text('Sin calidades registradas.')
                else
                  AppCardInfoGrid(
                    children: [
                      for (final calidad in vm.registradas)
                        AppCardInfoRow(
                          onTap: onEditCalidad == null || calidad.id == null
                              ? null
                              : () => Navigator.of(sheetContext).pop(calidad),
                          icon: Icons.verified_outlined,
                          label:
                              calidad.nombreCalidad ??
                              'Calidad #${calidad.idCalidad}',
                          value:
                              '${calidad.cantidad} jabas · ${calidad.precioUnitario == null ? 'Sin precio registrado' : 'Precio unitario: ${calidad.precioUnitario!.toStringAsFixed(2)}'}',
                        ),
                    ],
                  ),
                if (item.id != null && onAddCalidad != null) ...[
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Registrar calidad'),
                  ),
                ],
              ],
            );
          },
        );
        if (item.id == null) return content;
        return ChangeNotifierProvider(
          create: (_) =>
              sheetContext.read<DetalleCalidadViewModel Function()>()()
                ..loadRegistradas(item.id!),
          child: content,
        );
      },
    );
    if (addCalidad is DetalleCargaCalidad && context.mounted) {
      onEditCalidad?.call(addCalidad);
    }
    if (addCalidad == true && context.mounted) onAddCalidad?.call();
  }
}
