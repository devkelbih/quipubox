import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class RepartoAvance extends StatelessWidget {
  final String label;
  final int? cantidad;
  final int total;
  final String? pendiente;
  final bool revisar;
  const RepartoAvance({
    super.key,
    required this.label,
    required this.cantidad,
    required this.total,
    this.pendiente,
    this.revisar = false,
  });
  @override
  Widget build(BuildContext context) {
    final completo = total > 0 && cantidad == total && !revisar;
    final color = revisar
        ? Theme.of(context).colorScheme.error
        : completo
        ? AppColors.success
        : Theme.of(context).colorScheme.primary;
    return Semantics(
      label:
          '$label: ${cantidad == null ? 'sin datos completos' : '$cantidad de $total jabas'}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                cantidad == null ? 'Por verificar' : '$cantidad/$total',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 7),
          LinearProgressIndicator(
            value: cantidad == null
                ? 0
                : total > 0
                ? (cantidad! / total).clamp(0.0, 1.0)
                : 0,
            minHeight: 7,
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 5),
          Text(
            revisar
                ? 'Revisar cantidades: hay registros que superan la carga.'
                : cantidad == null
                ? 'La respuesta no incluye todas las cantidades.'
                : total == 0
                ? 'Sin mercadería registrada'
                : pendiente ??
                      (completo ? 'Completo' : 'Pendiente de completar'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: revisar
                  ? color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
