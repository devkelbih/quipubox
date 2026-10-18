import 'package:flutter/material.dart';

class AppCardActions extends StatelessWidget {
  final Widget primaryAction;
  final Widget secondaryAction;

  const AppCardActions({
    super.key,
    required this.primaryAction,
    required this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: secondaryAction),
        const SizedBox(width: 12),
        Expanded(child: primaryAction),
      ],
    );
  }
}