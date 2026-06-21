import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String heroImage =
      'https://www.agroperu.pe/wp-content/uploads/2024/10/agroperu-informa_gore-cusco-entrega-jabas-productores-palta-paruro.jpg';

  static const String crateImage =
      'https://palletsdemadera.com/wp-content/uploads/2025/01/cajas_madera_ecologicas-pallets-de-madera.jpg';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Quipubox',
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(Icons.notifications_none_rounded),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.sedes),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Registrar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          _HeroPanel(),
          SizedBox(height: 18),
          _QuickActions(),
          SizedBox(height: 18),
          _MetricsGrid(),
          SizedBox(height: 26),
          _SectionHeader(title: 'Entregas en curso', action: 'Ver todo'),
          SizedBox(height: 12),
          _DeliveriesSection(),
          SizedBox(height: 26),
          _SectionHeader(title: 'Trazabilidad del viaje', action: 'Detalle'),
          SizedBox(height: 12),
          _TimelinePanel(),
          SizedBox(height: 90),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 230,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: theme.colorScheme.primary,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(HomePage.heroImage, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: .82),
                  Colors.black.withValues(alpha: .28),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'Centro operativo logístico',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Control de cargas, entregas, jabas, retornos y evidencias en campo.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: .9),
                  ),
                ),
                const SizedBox(height: 14),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroChip(text: 'Dahe EIRL'),
                    _HeroChip(text: 'Cañete'),
                    _HeroChip(text: 'Lima'),
                    _HeroChip(text: 'Operación activa'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _QuickAction(
            icon: Icons.business_outlined,
            label: 'Sedes',
            route: AppRoutes.sedes,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _QuickAction(
            icon: Icons.groups_outlined,
            label: 'Clientes',
            route: AppRoutes.clientes,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _QuickAction(
            icon: Icons.category_outlined,
            label: 'Frutas',
            route: AppRoutes.frutas,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _QuickAction(
            icon: Icons.inventory_2_outlined,
            label: 'Jabas',
            route: AppRoutes.tiposJaba,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: .65,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.22,
      children: const [
        _MetricCard(
          title: 'Jabas pendientes',
          value: '1,245',
          detail: '+82 hoy',
          icon: Icons.inventory_2_outlined,
        ),
        _MetricCard(
          title: 'Entregas activas',
          value: '18',
          detail: '4 retrasadas',
          icon: Icons.local_shipping_outlined,
        ),
        _MetricCard(
          title: 'Retornos',
          value: '856',
          detail: '94% efectividad',
          icon: Icons.assignment_turned_in_outlined,
        ),
        _MetricCard(
          title: 'Incidencias',
          value: '7',
          detail: '2 críticas',
          icon: Icons.warning_amber_outlined,
        ),
      ],
    );
  }
}

class _DeliveriesSection extends StatelessWidget {
  const _DeliveriesSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DeliveryCard(
          imageUrl: HomePage.heroImage,
          title: 'Entrega palta Hass',
          route: 'Mala a Mercado Mayorista',
          detail: '120 jabas · Puesto 338 · Hace 18 min',
          status: 'En reparto',
          progress: .68,
        ),
        SizedBox(height: 14),
        _DeliveryCard(
          imageUrl: HomePage.crateImage,
          title: 'Retorno de jabas',
          route: 'Cliente Rosa a Cañete',
          detail: '50/80 jabas recibidas · Pendiente 30',
          status: 'Retorno parcial',
          progress: .62,
        ),
      ],
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String route;
  final String detail;
  final String status;
  final double progress;

  const _DeliveryCard({
    required this.imageUrl,
    required this.title,
    required this.route,
    required this.detail,
    required this.status,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 145,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: .65),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .18),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.route_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        route,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(detail)),
                  ],
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(99),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelinePanel extends StatelessWidget {
  const _TimelinePanel();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            _TimelineItem(
              time: '22:15',
              title: 'Carga registrada',
              detail: 'Mala · 320 jabas',
            ),
            _TimelineItem(
              time: '23:40',
              title: 'Camión salió',
              detail: 'Destino Lima',
            ),
            _TimelineItem(
              time: '01:20',
              title: 'Llegada a Lima',
              detail: 'Mercado Mayorista',
            ),
            _TimelineItem(
              time: '02:05',
              title: 'Entrega validada',
              detail: 'Puesto 338 · evidencia tomada',
            ),
            _TimelineItem(
              time: '03:12',
              title: 'Retorno parcial',
              detail: '50/80 jabas recibidas',
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String detail;

  const _TimelineItem({
    required this.time,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Text(
            time,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 42,
              color: theme.colorScheme.outlineVariant,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(detail),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String detail;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              detail,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const _SectionHeader({required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String text;

  const _HeroChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.white.withValues(alpha: .18),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
      side: BorderSide.none,
    );
  }
}
