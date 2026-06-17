import 'package:flutter/material.dart';

class AppDrawerFooter extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const AppDrawerFooter({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .22 : .08),
              blurRadius: 22,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            Material(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: isDark ? .32 : .42,
              ),
              borderRadius: BorderRadius.circular(20),
              child: SwitchListTile(
                value: isDarkMode,
                onChanged: (_) => onToggleTheme(),
                contentPadding: const EdgeInsets.fromLTRB(14, 4, 12, 4),

                // Color de la cápsula de fondo (Track)
                trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return theme.colorScheme.primary; // Azul cuando está activo
                  }
                  return theme
                      .colorScheme
                      .outlineVariant; // Tu gris más claro cuando está apagado
                }),
                // Color del borde de la cápsula
                trackOutlineColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.transparent;
                  }
                  return theme
                      .colorScheme
                      .primary; // Define la silueta cuando está apagado
                }),
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text(
                  'Modo oscuro',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                dense: true,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD32F2F),
                  backgroundColor: const Color(0xFFFFEDEE),
                  side: const BorderSide(color: Color(0xFFFFCDD2), width: 1.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
