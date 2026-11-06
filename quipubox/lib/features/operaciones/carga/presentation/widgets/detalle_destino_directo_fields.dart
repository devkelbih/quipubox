import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../organizacion/clientes/domain/entities/cliente_puesto.dart';
import '../viewmodels/detalle_carga_form_viewmodel.dart';

class DetalleDestinoDirectoFields extends StatelessWidget {
  const DetalleDestinoDirectoFields({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetalleCargaFormViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: vm.idReceptor,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Receptor de entrega directa',
          ),
          items: [
            for (final item in vm.receptoresDisponibles)
              DropdownMenuItem(
                value: item.id,
                child: Text(
                  item.nombreCompleto,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: vm.isSaving ? null : vm.selectReceptor,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<ClientePuesto>(
          key: ValueKey('puesto-${vm.idReceptor}'),
          initialValue: vm.puestoDirecto,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Puesto de destino'),
          items: [
            for (final relacion in vm.puestosDisponibles)
              DropdownMenuItem(
                value: relacion,
                child: Text(
                  '${relacion.puesto?.numeroPuesto ?? 'Puesto #${relacion.idPuesto}'}'
                  '${relacion.seccion == null ? '' : ' · Sección ${relacion.seccion!.label}'}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: vm.isSaving || vm.idReceptor == null
              ? null
              : vm.selectPuesto,
        ),
        if (vm.receptoresDisponibles.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              vm.operacion?.idSedeDestino == null
                  ? 'Define la sede de destino de la operación o activa reparto para asignar el destino después.'
                  : 'No hay receptores activos asociados a la sede de destino.',
            ),
          ),
        if (vm.idReceptor != null && vm.puestosDisponibles.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Este receptor no tiene puestos activos para la entrega directa.',
            ),
          ),
      ],
    );
  }
}
