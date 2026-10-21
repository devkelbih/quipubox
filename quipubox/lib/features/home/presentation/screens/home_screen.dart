import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';

/// Dashboard principal.
///
/// Los números, entregas, incidencias y la línea de tiempo son datos de
/// ejemplo (demo). Cuando tengas los ViewModels, reemplaza las constantes
/// `_demo...` por datos reales.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _onRefresh() async {
    // TODO: recargar métricas, entregas e incidencias desde los ViewModels.
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;
    final rawName = user?.nombres.value.split(' ').first ?? '';

    final sections = <Widget>[
      _GreetingHeader(
        firstName: rawName.isEmpty ? 'equipo' : rawName,
        company: user?.empresa.nombreComercial,
        sede: user?.sede.nombre,
        role: user?.rolesSummary,
      ),
      const _SummaryHero(),
      const _Section(title: 'Accesos directos', child: _QuickActions()),
      const _Section(title: 'Indicadores', child: _MetricsSection()),
      const _WeeklyChartCard(),
      const _Section(
        title: 'Retorno de jabas',
        action: 'Detalle',
        child: _ReturnsCard(),
      ),
      const _Section(
        title: 'Entregas en curso',
        action: 'Ver todo',
        child: _DeliveriesCarousel(),
      ),
      const _Section(
        title: 'Incidencias recientes',
        action: 'Ver todas',
        child: _IncidentsCard(),
      ),
      const _Section(
        title: 'Trazabilidad del viaje',
        action: 'Detalle',
        child: _TimelinePanel(),
      ),
    ];

    return AppScaffold(
      title: Image.asset('assets/logo.png', height: 36, fit: BoxFit.contain),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {},
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          itemCount: sections.length,
          separatorBuilder: (_, __) => const SizedBox(height: 22),
          itemBuilder: (_, i) => _Reveal(index: i, child: sections[i]),
        ),
      ),
    );
  }
}

// ============================================================================
// Utilidades
// ============================================================================

enum _Tone { brand, success, warning, danger }

extension on _Tone {
  Color color(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return switch (this) {
      _Tone.brand => theme.colorScheme.primary,
      _Tone.success => dark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
      _Tone.warning => dark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
      _Tone.danger => theme.colorScheme.error,
    };
  }
}

String _fmt(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

const _weekdays = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];
const _months = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

/// Animación de entrada suave (fade + desplazamiento) para cada bloque.
class _Reveal extends StatelessWidget {
  const _Reveal({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + math.min(index, 8) * 70),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - t)),
          child: child,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});

  final String title;
  final String? action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            if (action != null)
              TextButton(onPressed: () {}, child: Text(action!)),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({this.label, this.up, required this.tone});

  final String? label;
  final bool? up;
  final _Tone tone;

  @override
  Widget build(BuildContext context) {
    final color = tone.color(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (up != null) ...[
            Icon(
              up! ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 13,
              color: color,
            ),
            const SizedBox(width: 2),
          ],
          Text(
            label ?? '',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Saludo + resumen
// ============================================================================

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({
    required this.firstName,
    this.company,
    this.sede,
    this.role,
  });

  final String firstName;
  final String? company;
  final String? sede;
  final String? role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Buenos días'
        : now.hour < 19
        ? 'Buenas tardes'
        : 'Buenas noches';
    final date =
        '${_weekdays[now.weekday - 1]} ${now.day} de ${_months[now.month - 1]}';

    final chips = <(IconData, String)>[
      if (company != null && company!.isNotEmpty)
        (Icons.apartment_rounded, company!),
      if (sede != null && sede!.isNotEmpty) (Icons.place_outlined, sede!),
      if (role != null && role!.isNotEmpty && role != '-')
        (Icons.badge_outlined, role!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting · $date',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hola, $firstName',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _Tone.success.color(context).withValues(alpha: .14),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _Tone.success.color(context),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Operación activa',
                    style: TextStyle(
                      color: _Tone.success.color(context),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (chips.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in chips)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: .6,
                    ),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(c.$1, size: 15, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        c.$2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SummaryHero extends StatelessWidget {
  const _SummaryHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Degradado derivado del theme: navy -> teal (funciona en claro y oscuro).
    final start = Color.lerp(scheme.secondary, Colors.black, isDark ? .25 : 0)!;
    final end = Color.lerp(scheme.secondary, scheme.primary, .55)!;

    Widget bubble(double size, double alpha) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [start, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: start.withValues(alpha: .30),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(right: -36, top: -36, child: bubble(150, .08)),
          Positioned(right: 56, bottom: -60, child: bubble(130, .06)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_rounded,
                      size: 18,
                      color: Colors.white.withValues(alpha: .9),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Jabas pendientes de retorno',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: .9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '1,245',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .18),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        '+82 hoy',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(height: 1, color: Colors.white.withValues(alpha: .2)),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    _HeroStat(value: '320', label: 'Cargadas hoy'),
                    _HeroDivider(),
                    _HeroStat(value: '240', label: 'Entregadas'),
                    _HeroDivider(),
                    _HeroStat(value: '78', label: 'Retornadas'),
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

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDivider extends StatelessWidget {
  const _HeroDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withValues(alpha: .2),
    );
  }
}

// ============================================================================
// Accesos directos (se mantienen los 4 originales)
// ============================================================================
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  // Nota: Tienes items duplicados en tu lista original (Puestos, Frutas, Operativos se repiten).
  // Te dejo la lista limpia con los 4 originales.
  static const _items = <(IconData, String, String)>[
    (Icons.local_shipping_outlined, 'Cargas', AppRoutes.operacionesCarga),
    (Icons.business_outlined, 'Sedes', AppRoutes.sedes),
    (Icons.home_work_outlined, 'Puestos', AppRoutes.puestos),
    (Icons.category_outlined, 'Frutas', AppRoutes.frutas),
    (Icons.map_rounded, 'Operativos', AppRoutes.lugaresOperativos),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Envolvemos el ListView en un SizedBox para darle altura,
    // ya que al ser horizontal no puede calcular su altura por sí solo en un ListView vertical.
    return SizedBox(
      height: 110, // Altura suficiente para el icono + texto + padding
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none, // Para que las sombras o efectos no se corten
        physics: const BouncingScrollPhysics(), // Efecto de rebote suave
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          return SizedBox(
            width: 96, // Ancho fijo para que quepan bien y no se deformen
            child: InkWell(
              onTap: () => context.push(_items[i].$3),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(_items[i].$1, color: scheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        _items[i].$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// KPIs con mini gráfico
// ============================================================================

class _KpiData {
  const _KpiData({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.tone,
    required this.trend,
    required this.trendUp,
    required this.spark,
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final _Tone tone;
  final String trend;
  final bool trendUp;
  final List<double> spark;
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection();

  static const _kpis = [
    _KpiData(
      title: 'Entregas activas',
      value: '18',
      detail: '4 retrasadas',
      icon: Icons.local_shipping_outlined,
      tone: _Tone.brand,
      trend: '+3',
      trendUp: true,
      spark: [10, 12, 11, 14, 15, 16, 18],
    ),
    _KpiData(
      title: 'Retornos',
      value: '856',
      detail: '94% efectividad',
      icon: Icons.assignment_turned_in_outlined,
      tone: _Tone.success,
      trend: '+6%',
      trendUp: true,
      spark: [610, 640, 700, 690, 760, 810, 856],
    ),
    _KpiData(
      title: 'Incidencias',
      value: '7',
      detail: '2 críticas',
      icon: Icons.warning_amber_outlined,
      tone: _Tone.danger,
      trend: '+2',
      trendUp: true,
      spark: [3, 2, 4, 3, 5, 4, 7],
    ),
    _KpiData(
      title: 'Camiones en ruta',
      value: '12/15',
      detail: '3 disponibles',
      icon: Icons.fire_truck_outlined,
      tone: _Tone.warning,
      trend: '-1',
      trendUp: false,
      spark: [9, 11, 12, 13, 12, 13, 12],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget row(int a, int b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _KpiCard(data: _kpis[a])),
          const SizedBox(width: 12),
          Expanded(child: _KpiCard(data: _kpis[b])),
        ],
      ),
    );

    return Column(children: [row(0, 1), const SizedBox(height: 12), row(2, 3)]);
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data});

  final _KpiData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = data.tone.color(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, size: 20, color: color),
                ),
                const Spacer(),
                _TrendPill(
                  label: data.trend,
                  up: data.trendUp,
                  tone: data.tone,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              data.detail,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: CustomPaint(
                painter: _SparklinePainter(values: data.spark, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    final dx = size.width / (values.length - 1);

    Offset point(int i) => Offset(
      i * dx,
      size.height - ((values[i] - minV) / range) * (size.height - 4) - 2,
    );

    final line = Path()..moveTo(point(0).dx, point(0).dy);
    for (var i = 1; i < values.length; i++) {
      final prev = point(i - 1);
      final cur = point(i);
      final mid = (prev.dx + cur.dx) / 2;
      line.cubicTo(mid, prev.dy, mid, cur.dy, cur.dx, cur.dy);
    }

    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .28), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.values != values || old.color != color;
}

// ============================================================================
// Gráfico semanal (barras animadas, sin paquetes externos)
// ============================================================================

class _WeeklyChartCard extends StatelessWidget {
  const _WeeklyChartCard();

  static const _values = [620, 840, 710, 960, 880, 1150, 1245];
  static const _letters = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final today = DateTime.now();
    final total = _values.fold<int>(0, (a, b) => a + b);
    final maxV = _values.reduce(math.max);
    const barArea = 110.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jabas movilizadas',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Últimos 7 días',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _fmt(total),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const _TrendPill(
                      label: '+12%',
                      up: true,
                      tone: _Tone.success,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, t, _) => SizedBox(
                height: barArea + 52,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_values.length, (i) {
                    final isToday = i == _values.length - 1;
                    final date = today.subtract(
                      Duration(days: _values.length - 1 - i),
                    );

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isToday)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: FittedBox(
                                  child: Text(
                                    _fmt(_values[i]),
                                    style: TextStyle(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              height: barArea * (_values[i] / maxV) * t,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? scheme.primary
                                    : scheme.primary.withValues(alpha: .22),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _letters[date.weekday - 1],
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: isToday
                                    ? scheme.onSurface
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Retorno de jabas (anillo de progreso)
// ============================================================================

class _ReturnsCard extends StatelessWidget {
  const _ReturnsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 112,
              height: 112,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: .94),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size.square(112),
                      painter: _RingPainter(
                        progress: value,
                        color: scheme.primary,
                        track: scheme.outlineVariant,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(value * 100).round()}%',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'efectividad',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _LegendRow(
                    color: scheme.primary,
                    label: 'Recibidas',
                    value: '856',
                  ),
                  const SizedBox(height: 12),
                  _LegendRow(
                    color: _Tone.warning.color(context),
                    label: 'Pendientes',
                    value: '40',
                  ),
                  const SizedBox(height: 12),
                  _LegendRow(
                    color: scheme.error,
                    label: 'Observadas',
                    value: '15',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  static const _stroke = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(_stroke / 2);

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, base..color = track);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      base..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track;
}

// ============================================================================
// Entregas en curso (carrusel horizontal)
// ============================================================================

class _DeliveryData {
  const _DeliveryData({
    required this.title,
    required this.origin,
    required this.destination,
    required this.detail,
    required this.status,
    required this.ago,
    required this.tone,
    required this.progress,
  });

  final String title;
  final String origin;
  final String destination;
  final String detail;
  final String status;
  final String ago;
  final _Tone tone;
  final double progress;
}

class _DeliveriesCarousel extends StatelessWidget {
  const _DeliveriesCarousel();

  static const _items = [
    _DeliveryData(
      title: 'Entrega palta Hass',
      origin: 'Mala',
      destination: 'Mercado Mayorista',
      detail: '120 jabas · Puesto 338',
      status: 'En reparto',
      ago: 'Hace 18 min',
      tone: _Tone.brand,
      progress: .68,
    ),
    _DeliveryData(
      title: 'Retorno de jabas',
      origin: 'Cliente Rosa',
      destination: 'Cañete',
      detail: '50/80 jabas recibidas · Pendiente 30',
      status: 'Retorno parcial',
      ago: 'Hace 1 h',
      tone: _Tone.warning,
      progress: .62,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 214,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) =>
            SizedBox(width: 292, child: _DeliveryCard(data: _items[i])),
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.data});

  final _DeliveryData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TrendPill(label: data.status, tone: data.tone),
                const Spacer(),
                Text(
                  data.ago,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: Text(
                    data.origin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 20,
                    color: scheme.primary,
                  ),
                ),
                Flexible(
                  child: Text(
                    data.destination,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data.detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: data.progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(data.progress * 100).round()}%',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Incidencias
// ============================================================================

class _IncidentsCard extends StatelessWidget {
  const _IncidentsCard();

  static const _items = <(IconData, _Tone, String, String, String)>[
    (
      Icons.error_outline_rounded,
      _Tone.danger,
      'Camión con retraso',
      'Mala → Mercado Mayorista · +25 min',
      'Hace 10 min',
    ),
    (
      Icons.assignment_late_outlined,
      _Tone.danger,
      'Retorno incompleto',
      'Cliente Rosa · faltan 30 jabas',
      'Hace 1 h',
    ),
    (
      Icons.photo_camera_outlined,
      _Tone.warning,
      'Evidencia pendiente',
      'Puesto 338 · falta foto de entrega',
      'Hace 2 h',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0) const Divider(indent: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _items[i].$2.color(context).withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _items[i].$1,
                      color: _items[i].$2.color(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _items[i].$3,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].$4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _items[i].$5,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// Trazabilidad
// ============================================================================

class _TimelinePanel extends StatelessWidget {
  const _TimelinePanel();

  static const _items = <(String, String, String)>[
    ('22:15', 'Carga registrada', 'Mala · 320 jabas'),
    ('23:40', 'Camión salió', 'Destino Lima'),
    ('01:20', 'Llegada a Lima', 'Mercado Mayorista'),
    ('02:05', 'Entrega validada', 'Puesto 338 · evidencia tomada'),
    ('03:12', 'Retorno parcial', '50/80 jabas recibidas'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          children: [
            for (var i = 0; i < _items.length; i++)
              _TimelineItem(
                time: _items[i].$1,
                title: _items[i].$2,
                detail: _items[i].$3,
                isLast: i == _items.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.time,
    required this.title,
    required this.detail,
    required this.isLast,
  });

  final String time;
  final String title;
  final String detail;

  /// El último evento se muestra como "en curso".
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              time,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: scheme.primary,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLast ? scheme.surface : scheme.primary,
                  border: isLast
                      ? Border.all(color: scheme.primary, width: 3)
                      : null,
                ),
                child: isLast
                    ? null
                    : Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: scheme.onPrimary,
                      ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: scheme.primary.withValues(alpha: .35),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
