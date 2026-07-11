import 'package:flutter/material.dart';
import 'drawer_metrics.dart';
import 'drawer_styles.dart';

/// ===============================================================
/// AppDrawerHeader
/// ---------------------------------------------------------------
/// Header del drawer con información del usuario.
/// ===============================================================
class AppDrawerHeader extends StatelessWidget {
  final double topPadding;
  final String? avatarUrl;
  final String name;
  final String role;
  final String site;
  final VoidCallback? onTap;

  const AppDrawerHeader({
    super.key,
    required this.topPadding,
    required this.avatarUrl,
    required this.name,
    required this.role,
    required this.site,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(DrawerMetrics.cardRadius),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPadding + 12,
            bottom: 12,
          ),
          decoration: DrawerStyles.headerDecoration(colorScheme),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Círculo decorativo
              _buildDecorationCircle(),
              // Contenido
              _buildHeaderContent(),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // Widgets internos
  // =============================================================

  Widget _buildDecorationCircle() {
    return Positioned(
      top: -55,
      right: -45,
      child: Container(
        width: 165,
        height: 165,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .07),
        ),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          _buildAvatar(),
          const SizedBox(width: 14),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nombre
                _buildNameRow(),
                const SizedBox(height: 6),
                // Divisor
                _buildDivider(),
                const SizedBox(height: 8),
                // Chips
                _buildChipsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: DrawerStyles.avatarShadow(),
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: .70),
            width: 2.2,
          ),
        ),
        child: _CustomAvatar(
          avatarUrl: avatarUrl,
          radius: DrawerMetrics.avatarRadius,
        ),
      ),
    );
  }

  Widget _buildNameRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: .2,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: DrawerMetrics.navigationIconSize,
          color: Colors.white.withValues(alpha: .7),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: DrawerMetrics.dividerWidth,
      height: DrawerMetrics.dividerHeight,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _buildChipsRow() {
    return Row(
      children: [
        _HeaderChip(
          icon: Icons.badge_rounded,
          text: role,
        ),
        const Spacer(),
        _HeaderChip(
          icon: Icons.location_on_rounded,
          text: site,
        ),
      ],
    );
  }
}

// ===============================================================
// Widgets privados
// ===============================================================

class _CustomAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;

  const _CustomAvatar({
    required this.avatarUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primary,
      child: avatarUrl?.isNotEmpty == true
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            )
          : const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 30,
            ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeaderChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: DrawerStyles.headerChipDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: DrawerMetrics.iconSize - 5, // 15
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: DrawerMetrics.subtitleSize, // 11.8
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}