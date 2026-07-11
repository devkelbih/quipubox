import 'package:flutter/material.dart';
import 'drawer_metrics.dart';
import 'drawer_styles.dart';

/// ===============================================================
/// AppDrawerFooter
/// ---------------------------------------------------------------
/// Footer del drawer con opciones de tema y logout.
/// ===============================================================
class AppDrawerFooter extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;
  final bool isSigningOut;

  const AppDrawerFooter({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
    required this.isSigningOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          DrawerMetrics.outerPadding,
          12,
          DrawerMetrics.outerPadding,
          14,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: DrawerStyles.footerShadow(theme),
        ),
        child: Column(
          children: [
            // Switch de tema
            _buildThemeSwitch(theme),
            const SizedBox(height: 12),
            // Botón de logout
            _buildLogoutButton(theme),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // Widgets internos
  // =============================================================

  Widget _buildThemeSwitch(ThemeData theme) {
    return Container(
      decoration: DrawerStyles.themeSwitchDecoration(theme),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DrawerMetrics.subCardRadius),
        child: SwitchListTile(
          value: isDarkMode,
          onChanged: (_) => onToggleTheme(),
          contentPadding: const EdgeInsets.fromLTRB(14, 4, 12, 4),

          // Color de la cápsula de fondo (Track)
          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary; // Azul cuando está activo
            }
            return theme.colorScheme.outlineVariant; // Gris cuando está apagado
          }),

          // Color del borde de la cápsula
          trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.transparent;
            }
            return theme.colorScheme.primary; // Silueta cuando está apagado
          }),

          secondary: _buildThemeIcon(theme),
          title: const Text(
            'Modo oscuro',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          dense: true,
        ),
      ),
    );
  }

  Widget _buildThemeIcon(ThemeData theme) {
    return Container(
      width: DrawerMetrics.iconContainerSize,
      height: DrawerMetrics.iconContainerSize,
      decoration: DrawerStyles.themeIconDecoration(theme),
      child: Icon(
        isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        color: theme.colorScheme.primary,
        size: DrawerMetrics.iconSize,
      ),
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: DrawerMetrics.footerButtonHeight,
      child: OutlinedButton.icon(
        onPressed: isSigningOut ? null : onLogout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Cerrar sesión'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,

          backgroundColor: theme.colorScheme.errorContainer,

          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: .20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DrawerMetrics.subCardRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
