import '../../domain/entities/detalle_carga_calidad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../viewmodels/detalle_calidad_viewmodel.dart';
import 'detalle_calidad_form.dart';

class DetalleCalidadSheet {
  const DetalleCalidadSheet._();

  static Future<bool?> show({
    required BuildContext context,
    required int detalleId,
    DetalleCargaCalidad? editing,
    required int cantidadTotal,
  }) => AppBottomSheet.show<bool>(
    context: context,
    title: editing == null ? 'Agregar calidad' : 'Editar calidad',
    minChildSize: .6,
    initialChildSize: .65,
    maxChildSize: .70,
    builder: (context, controller) => ChangeNotifierProvider(
      create: (_) => context.read<DetalleCalidadViewModel Function()>()(),
      child: DetalleCalidadForm(
        detalleId: detalleId,
        editing: editing,
        cantidadTotal: cantidadTotal,
        scrollController: controller,
      ),
    ),
  );
}
