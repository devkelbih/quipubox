import 'package:flutter/material.dart';

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
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(32)),

        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18, topPadding + 18, 18, 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(32),
            ),
          ),
          child: SizedBox(
            height: 92,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
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
                ),

                Positioned(
                  bottom: -45,
                  right: 35,
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: .05),
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
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
                        child: _CustomAvatar(avatarUrl: avatarUrl, radius: 30),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
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
                                Icons.chevron_right_rounded,
                                size: 22,
                                color: Colors.white.withValues(alpha: .85),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Container(
                            width: 46,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .35),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;

  const _CustomAvatar({required this.avatarUrl, required this.radius});

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
          : const Icon(Icons.person_rounded, color: Colors.white, size: 30),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeaderChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: .22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
