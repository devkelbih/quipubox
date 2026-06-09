import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();

    return AppScaffold(
      title: 'Ajustes',
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: SwitchListTile(
              value: settings.isDarkMode,
              onChanged: (_) => context.read<SettingsViewModel>().toggleTheme(),
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Modo oscuro', style: TextStyle(fontWeight: FontWeight.w900)),
              subtitle: const Text('Cambia el tema visual de toda la aplicación.'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_suggest_outlined),
              title: const Text('Usar tema del sistema', style: TextStyle(fontWeight: FontWeight.w900)),
              subtitle: const Text('La app seguirá la configuración del dispositivo.'),
              onTap: () => context.read<SettingsViewModel>().useSystemTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
