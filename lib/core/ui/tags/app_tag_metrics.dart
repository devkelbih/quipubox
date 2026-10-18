import 'package:flutter/material.dart';

import 'app_tag.dart';

class AppTagMetrics {
  final EdgeInsets padding;
  final double radius;
  final double fontSize;
  final double iconSize;

  const AppTagMetrics({
    required this.padding,
    required this.radius,
    required this.fontSize,
    required this.iconSize,
  });

  static AppTagMetrics fromSize(AppTagSize size) {
    switch (size) {
      case AppTagSize.small:
        return const AppTagMetrics(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          radius: 8,
          fontSize: 11,
          iconSize: 14,
        );

      case AppTagSize.medium:
        return const AppTagMetrics(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          radius: 8,
          fontSize: 12,
          iconSize: 15,
        );

      case AppTagSize.large:
        return const AppTagMetrics(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          radius: 8,
          fontSize: 13,
          iconSize: 16,
        );
    }
  }
}