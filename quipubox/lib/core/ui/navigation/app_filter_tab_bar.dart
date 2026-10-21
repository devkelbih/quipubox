// lib/core/ui/tabs/app_filter_tab_bar.dart
import 'package:flutter/material.dart';

/// Filtro de dominio para listas operativas.
/// NO incluye "Todos": lo antepone [AppFilterTabBar] automáticamente.
class AppFilterTab {
  final String value;
  final String label;
  final int count;
  const AppFilterTab({
    required this.value,
    required this.label,
    required this.count,
  });
}

/// Barra de filtros para listas operativas con N statuses de dominio.
///
/// Garantías del componente:
/// - **"Todos" siempre existe y es el primer tab** (se antepone aquí).
/// - **No recarga datos**: solo notifica el cambio de tab vía [onChanged].
/// - Para catálogos CRUD (all/active/inactive) usar `AppStatusTabBar`.
class AppFilterTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Tabs de dominio, SIN incluir "Todos".
  final List<AppFilterTab> tabs;

  /// Valor seleccionado. Si no coincide con ningún tab, se resalta "Todos".
  final String selected;
  final ValueChanged<String> onChanged;

  /// Valor reservado para el tab "Todos".
  final String allValue;

  /// Etiqueta del tab "Todos".
  final String allLabel;

  /// Ancho mínimo por tab; si el contenido es mayor, crece.
  final double minTabWidth;

  /// Total real para el tab "Todos".
  /// Si es null, se calcula como la suma de los counts de [tabs].
  /// Úsalo cuando los tabs puedan solaparse (un item en dos tabs),
  /// p. ej. 'completada' agrupando 'completado' + 'cancelada'.
  final int? totalOverride;

  const AppFilterTabBar({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onChanged,
    this.allValue = 'todos',
    this.allLabel = 'Todos',
    this.minTabWidth = 92,
    this.totalOverride,
  }) : assert(tabs.length > 0, 'Debe haber al menos un tab de dominio');

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // "Todos" = totalOverride si se pasa; si no, suma de los tabs.
    final allCount =
        totalOverride ?? tabs.fold<int>(0, (acc, t) => acc + t.count);

    final hasSelection =
        selected == allValue || tabs.any((t) => t.value == selected);
    final effectiveSelected = hasSelection ? selected : allValue;

    final allTabs = <AppFilterTab>[
      AppFilterTab(value: allValue, label: allLabel, count: allCount),
      ...tabs,
    ];

    return Material(
      color: colorScheme.surfaceContainerLowest,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: .45),
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final tab in allTabs)
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: minTabWidth),
                  child: _AppFilterTab(
                    label: tab.label,
                    count: tab.count,
                    selected: effectiveSelected == tab.value,
                    onTap: () => onChanged(tab.value),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppFilterTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _AppFilterTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = selected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: color,
                      ),
                      child: Text(
                        '$label ($count)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: selected ? 36 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
