import 'package:flutter/material.dart';

import 'auth_entry_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthEntryScreen(isCheckingSession: true);
  }
}
