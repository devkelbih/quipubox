import 'package:flutter/material.dart';

/// ===============================================================
/// Drawer Metrics
/// ---------------------------------------------------------------
/// Todas las medidas utilizadas por el Drawer.
/// Aquí NO van colores ni decoraciones.
/// ===============================================================
abstract final class DrawerMetrics {
  const DrawerMetrics._();

  //========================
  // Drawer
  //========================

  static const double widthFactor = .86;
  static const double outerPadding = 14;

  //========================
  // Cards
  //========================

  static const double cardRadius = 22;
  static const double subCardRadius = 14;

  static const double cardSpacing = 10;

  //========================
  // Tile
  //========================

  static const EdgeInsets tilePadding = EdgeInsets.fromLTRB(14, 8, 10, 8);

  static const EdgeInsets childrenPadding = EdgeInsets.fromLTRB(14, 0, 14, 14);

  static const EdgeInsets subTilePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  );

  //========================
  // Icon
  //========================

  static const double iconContainerSize = 42;

  static const double iconRadius = 14;

  static const double iconSize = 20;

  static const double navigationIconSize = 18;

  static const double statusDot = 8;

  //========================
  // Typography
  //========================

  static const double titleSize = 14.5;

  static const double subtitleSize = 11.8;

  static const double subItemSize = 13;

  static const double sectionSize = 11;

  //========================
  // Header
  //========================

  static const double avatarRadius = 30;

  static const double chipRadius = 12;

  static const double dividerWidth = 46;

  static const double dividerHeight = 2;

  //========================
  // Footer
  //========================

  static const double footerButtonHeight = 54;
}
