import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_rounded, size: 72),
          SizedBox(height: 18),
          Text(
            'Quipubox',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10),
          Text('Preparando sesión...'),
          SizedBox(height: 22),
          CircularProgressIndicator(),
        ],
      ),
    ),
  );
}
