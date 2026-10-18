import 'package:flutter/material.dart';

class UsuarioFormStepper extends StatelessWidget {
  final int currentStep;
  final Set<int> completedSteps;
  final Set<int> errorSteps;
  final ValueChanged<int>? onStepTapped;

  const UsuarioFormStepper({
    super.key,
    required this.currentStep,
    this.completedSteps = const {},
    this.errorSteps = const {},
    this.onStepTapped,
  });

  static const _steps = [
    _UsuarioFormStepData(
      title: 'Datos',
      subtitle: 'Información personal',
    ),
    _UsuarioFormStepData(
      title: 'Sede',
      subtitle: 'Ubicación',
    ),
    _UsuarioFormStepData(
      title: 'Roles',
      subtitle: 'Permisos',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int index = 0; index < _steps.length; index++) ...[
            Expanded(
              child: _buildStep(
                context,
                index: index,
                data: _steps[index],
                colorScheme: colorScheme,
              ),
            ),

            if (index < _steps.length - 1)
              _buildConnector(
                completed: completedSteps.contains(index),
                error: errorSteps.contains(index + 1),
                colorScheme: colorScheme,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required int index,
    required _UsuarioFormStepData data,
    required ColorScheme colorScheme,
  }) {
    final isCompleted = completedSteps.contains(index);
    final isError = errorSteps.contains(index);
    final isCurrent = currentStep == index;

    // Un paso puede tocarse si ya fue alcanzado.
    final isEnabled = index <= currentStep;

    return InkWell(
      onTap: isEnabled ? () => onStepTapped?.call(index) : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            _buildIndicator(
              context,
              index: index,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isError: isError,
              colorScheme: colorScheme,
            ),

            const SizedBox(height: 10),

            Text(
              data.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: isCurrent || isCompleted
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: _getTitleColor(
                  index: index,
                  isCurrent: isCurrent,
                  isCompleted: isCompleted,
                  isError: isError,
                  colorScheme: colorScheme,
                ),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getSubtitleColor(
                  index: index,
                  isCurrent: isCurrent,
                  isError: isError,
                  colorScheme: colorScheme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(
    BuildContext context, {
    required int index,
    required bool isCompleted,
    required bool isCurrent,
    required bool isError,
    required ColorScheme colorScheme,
  }) {
    final indicatorColor = _getIndicatorColor(
      isCompleted: isCompleted,
      isCurrent: isCurrent,
      isError: isError,
      colorScheme: colorScheme,
    );

    final backgroundColor = _getIndicatorBackgroundColor(
      isCompleted: isCompleted,
      isCurrent: isCurrent,
      isError: isError,
      colorScheme: colorScheme,
    );

    final foregroundColor = _getIndicatorForegroundColor(
      isCompleted: isCompleted,
      isCurrent: isCurrent,
      isError: isError,
      colorScheme: colorScheme,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: indicatorColor,
          width: isCurrent ? 2 : 1.5,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: _buildIndicatorContent(
          context,
          index: index,
          isCompleted: isCompleted,
          isError: isError,
          isCurrent: isCurrent,
          foregroundColor: foregroundColor,
          colorScheme: colorScheme,
        ),
      ),
    );
  }

  Widget _buildIndicatorContent(
    BuildContext context, {
    required int index,
    required bool isCompleted,
    required bool isError,
    required bool isCurrent,
    required Color foregroundColor,
    required ColorScheme colorScheme,
  }) {
    if (isError) {
      return Icon(
        Icons.priority_high_rounded,
        key: const ValueKey('error'),
        size: 20,
        color: foregroundColor,
      );
    }

    if (isCompleted) {
      return Icon(
        Icons.check_rounded,
        key: const ValueKey('completed'),
        size: 20,
        color: foregroundColor,
      );
    }

    return Text(
      '${index + 1}',
      key: ValueKey('index-$index'),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: foregroundColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildConnector({
    required bool completed,
    required bool error,
    required ColorScheme colorScheme,
  }) {
    final color = error
        ? colorScheme.error
        : completed
            ? colorScheme.primary
            : colorScheme.outlineVariant;

    return Padding(
      padding: const EdgeInsets.only(top: 17),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 2,
        width: 24,
        color: color,
      ),
    );
  }

  Color _getIndicatorColor({
    required bool isCompleted,
    required bool isCurrent,
    required bool isError,
    required ColorScheme colorScheme,
  }) {
    if (isError) {
      return colorScheme.error;
    }

    if (isCompleted || isCurrent) {
      return colorScheme.primary;
    }

    return colorScheme.outlineVariant;
  }

  Color _getIndicatorBackgroundColor({
    required bool isCompleted,
    required bool isCurrent,
    required bool isError,
    required ColorScheme colorScheme,
  }) {
    if (isError) {
      return colorScheme.errorContainer;
    }

    if (isCompleted || isCurrent) {
      return colorScheme.primary;
    }

    return colorScheme.surface;
  }

  Color _getIndicatorForegroundColor({
    required bool isCompleted,
    required bool isCurrent,
    required bool isError,
    required ColorScheme colorScheme,
  }) {
    if (isError) {
      return colorScheme.onErrorContainer;
    }

    if (isCompleted || isCurrent) {
      return colorScheme.onPrimary;
    }

    return colorScheme.onSurfaceVariant;
  }

  Color _getTitleColor({
    required int index,
    required bool isCurrent,
    required bool isCompleted,
    required bool isError,
    required ColorScheme colorScheme,
  }) {
    if (isError) {
      return colorScheme.error;
    }

    if (isCurrent || isCompleted) {
      return colorScheme.onSurface;
    }

    return colorScheme.onSurfaceVariant;
  }

  Color _getSubtitleColor({
    required int index,
    required bool isCurrent,
    required bool isError,
    required ColorScheme colorScheme,
  }) {
    if (isError) {
      return colorScheme.error;
    }

    return colorScheme.onSurfaceVariant;
  }
}

class _UsuarioFormStepData {
  final String title;
  final String subtitle;

  const _UsuarioFormStepData({
    required this.title,
    required this.subtitle,
  });
}