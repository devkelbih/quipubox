import 'package:flutter/material.dart';
import 'drawer_metrics.dart';

/// ===============================================================
/// Drawer Styles
/// ---------------------------------------------------------------
/// Estilos reutilizables para todos los componentes del Drawer.
/// Aquí NO van widgets.
/// ===============================================================
abstract final class DrawerStyles {
  const DrawerStyles._();

  //==============================================================
  // Tarjeta principal
  //==============================================================

  static BoxDecoration cardDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(DrawerMetrics.cardRadius),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: .85),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: theme.brightness == Brightness.dark ? .18 : .045,
          ),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  //==============================================================
  // Tarjeta secundaria (SubItem)
  //==============================================================

  static BoxDecoration subTileDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .45),
      borderRadius: BorderRadius.circular(DrawerMetrics.subCardRadius),
    );
  }

  //==============================================================
  // Contenedor del icono
  //==============================================================

  static BoxDecoration iconContainer(
    ThemeData theme,
    Color color,
  ) {
    return BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(DrawerMetrics.iconRadius),
    );
  }

  //==============================================================
  // Header
  //==============================================================

  static BoxDecoration headerDecoration(ColorScheme colors) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          colors.primary,
          colors.secondary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(DrawerMetrics.cardRadius),
      ),
    );
  }

  //==============================================================
  // Header Chip
  //==============================================================

  static BoxDecoration headerChipDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(DrawerMetrics.chipRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: .22),
      ),
    );
  }

  //==============================================================
  // Avatar Shadow
  //==============================================================

  static List<BoxShadow> avatarShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: .15),
        blurRadius: 12,
        offset: const Offset(0, 5),
      ),
    ];
  }

  //==============================================================
  // Card Shadow (por si algún widget la necesita sola)
  //==============================================================

  static List<BoxShadow> cardShadow(ThemeData theme) {
    return [
      BoxShadow(
        color: Colors.black.withValues(
          alpha: theme.brightness == Brightness.dark ? .18 : .045,
        ),
        blurRadius: 18,
        offset: const Offset(0, 7),
      ),
    ];
  }

  //==============================================================
  // Footer
  //==============================================================

  static List<BoxShadow> footerShadow(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(
          alpha: isDark ? .22 : .08,
        ),
        blurRadius: 12,
        offset: const Offset(0, -2),
      ),
    ];
  }

  static BoxDecoration themeSwitchDecoration(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: isDark ? .32 : .42,
      ),
      borderRadius: BorderRadius.circular(DrawerMetrics.subCardRadius),
    );
  }

  static BoxDecoration themeIconDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.primary.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(DrawerMetrics.iconRadius),
    );
  }
}