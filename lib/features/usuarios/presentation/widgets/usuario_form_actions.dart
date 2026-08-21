import 'package:flutter/material.dart';

class UsuarioFormActions extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const UsuarioFormActions({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onContinue,
  });

  bool get isFirstStep => currentStep == 0;

  bool get isLastStep => currentStep == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            if (isFirstStep)
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  child: const Text('Cancelar'),
                ),
              )
            else
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Atrás'),
                ),
              ),

            const SizedBox(width: 12),

            Expanded(
              child: FilledButton.icon(
                onPressed: onContinue,
                icon: Icon(
                  isLastStep
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                ),
                label: Text(
                  isLastStep ? 'Guardar' : 'Continuar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}