import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/layout/app_scaffold.dart';
import '../viewmodels/settings_viewmodel.dart';
class SettingsPage extends StatelessWidget { const SettingsPage({super.key}); @override Widget build(BuildContext context) { final vm = context.watch<SettingsViewModel>(); return AppScaffold(title: 'Ajustes', body: ListView(padding: const EdgeInsets.all(16), children: [Card(child: Column(children: [for (final item in [(ThemeMode.system, 'Sistema'), (ThemeMode.light, 'Claro'), (ThemeMode.dark, 'Oscuro')]) ListTile(title: Text(item.$2, style: const TextStyle(fontWeight: FontWeight.w800)), trailing: vm.themeMode == item.$1 ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.circle_outlined), onTap: () => context.read<SettingsViewModel>().setThemeMode(item.$1))]))])); } }
