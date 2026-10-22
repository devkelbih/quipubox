import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
import 'package:quipubox/core/ui/cards/app_card_quick_actions.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/status/app_status_colors.dart';

Widget host(Widget child, {ThemeData? theme, double scale = 1}) => MaterialApp(
  theme: theme ?? AppTheme.light,
  home: Scaffold(
    body: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: SingleChildScrollView(child: SizedBox(width: 280, child: child)),
    ),
  ),
);

const header = AppCardHeader(icon: Icon(Icons.eco), title: 'Fruta');

void main() {
  testWidgets('Estado junto al menú dentro de la fila del encabezado', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        AppCard(
          header: AppCardHeader(
            icon: const Icon(Icons.eco),
            title: 'Fruta',
            subtitle: 'Dato',
            badge: const AppStatusBadge(
              status: AppStatus(label: 'Activo', type: AppStatusType.success),
            ),
            menu: AppCardMenu(
              actions: [
                AppCardMenuAction(
                  icon: Icons.edit,
                  label: 'Editar',
                  onSelected: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final menu = tester.getRect(find.byType(AppCardMenu));
    final badge = tester.getRect(find.byType(AppStatusBadge));
    final title = tester.getRect(find.text('Fruta'));
    expect(badge.center.dy, closeTo(menu.center.dy, 0.01));
    expect(badge.right, lessThan(menu.left));
    final contentBottom = [
      title.bottom,
      tester.getRect(find.text('Dato')).bottom,
      menu.bottom,
      badge.bottom,
      tester.getRect(find.byIcon(Icons.eco)).bottom,
    ].reduce((a, b) => a > b ? a : b);
    expect(
      tester.getRect(find.byType(AppCardHeader)).bottom,
      closeTo(contentBottom, 0.01),
    );
    expect(badge.left, greaterThan(title.right));
    expect(tester.takeException(), isNull);
  });
  testWidgets('Dos acciones caben en una fila con ancho suficiente', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 420,
            child: AppCardActions(
              navigationAction: AppCardQuickAction(
                icon: Icons.list,
                label: 'Ver detalles',
                onPressed: () {},
              ),
              operationalAction: AppCardQuickAction(
                icon: Icons.add,
                label: 'Asignar carga',
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
    final navigation = tester.getCenter(find.byType(TextButton));
    final operation = tester.getCenter(find.byType(FilledButton));
    expect(navigation.dy, operation.dy);
    expect(navigation.dx, lessThan(operation.dx));
    final footer = tester.getRect(find.byType(AppCardActions));
    final divider = tester.getRect(find.byType(Divider));
    expect(divider.width, closeTo(footer.width * 0.4, 0.01));
    expect(divider.left, closeTo(footer.left, 0.01));
    expect(tester.takeException(), isNull);
  });
  for (final dark in [false, true]) {
    testWidgets('Contenido largo en móvil, tema oscuro=$dark', (tester) async {
      const title = 'Nombre completo de una operación con una ruta muy larga';
      await tester.pumpWidget(
        host(
          AppCard(
            header: AppCardHeader(
              icon: const Icon(Icons.eco),
              title: title,
              subtitle: '$title $title',
              badge: const AppStatusBadge(
                status: AppStatus(
                  label:
                      'Estado con una descripción extensa que debe ajustarse',
                  type: AppStatusType.warning,
                ),
              ),
              menu: AppCardMenu(
                actions: [
                  AppCardMenuAction(
                    icon: Icons.edit,
                    label: 'Editar',
                    onSelected: () {},
                  ),
                ],
              ),
            ),
            body: const AppCardBody(
              child: AppCardInfoRow(
                icon: Icons.route,
                label: 'Ruta',
                value: '$title $title',
              ),
            ),
            quickActions: AppCardQuickActions(
              navigationAction: AppCardQuickAction(
                icon: Icons.list,
                label: 'Consultar todas las variedades de la fruta',
                onPressed: () {},
              ),
              operationalAction: AppCardQuickAction(
                icon: Icons.add,
                label: 'Asignar carga a la operación seleccionada',
                onPressed: () {},
              ),
            ),
          ),
          theme: dark ? AppTheme.dark : AppTheme.light,
          scale: 2,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byTooltip(title), findsOneWidget);
      await tester.longPress(find.text(title));
      await tester.pumpAndSettle();
      expect(find.text(title), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'El menú conserva callbacks y respeta acciones ocultas y deshabilitadas',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        host(
          AppCard(
            header: AppCardHeader(
              icon: const Icon(Icons.eco),
              title: 'Fruta',
              menu: AppCardMenu(
                actions: [
                  AppCardMenuAction(
                    icon: Icons.edit,
                    label: 'Editar',
                    onSelected: () => calls++,
                  ),
                  AppCardMenuAction(
                    icon: Icons.block,
                    label: 'Desactivar',
                    enabled: false,
                    onSelected: () => calls += 10,
                  ),
                  AppCardMenuAction(
                    icon: Icons.delete,
                    label: 'Oculta',
                    visible: false,
                    onSelected: () => calls += 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Más acciones'));
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(find.text('Oculta'), findsNothing);
      final disabled = tester.widget<PopupMenuItem<AppCardMenuAction>>(
        find.ancestor(
          of: find.text('Desactivar'),
          matching: find.byType(PopupMenuItem<AppCardMenuAction>),
        ),
      );
      expect(disabled.enabled, isFalse);
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      expect(calls, 1);
    },
  );

  testWidgets('Acciones rápidas ejecutan solo su callback', (tester) async {
    var navigation = 0;
    var operation = 0;
    await tester.pumpWidget(
      host(
        AppCard(
          header: header,
          quickActions: AppCardQuickActions(
            navigationAction: AppCardQuickAction(
              icon: Icons.list,
              label: 'Ver detalles',
              onPressed: () => navigation++,
            ),
            operationalAction: AppCardQuickAction(
              icon: Icons.add,
              label: 'Asignar',
              onPressed: () => operation++,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Ver detalles'));
    expect(navigation, 1);
    expect(operation, 0);
    await tester.tap(find.text('Asignar'));
    expect(operation, 1);
  });

  testWidgets('Secciones opcionales vacías no dejan espacio', (tester) async {
    await tester.pumpWidget(host(const AppCard(header: header)));
    final height = tester.getSize(find.byType(Card)).height;
    await tester.pumpWidget(
      host(const AppCard(header: header, quickActions: AppCardQuickActions())),
    );
    expect(tester.getSize(find.byType(Card)).height, height);
    expect(find.byType(Divider), findsNothing);
    await tester.pumpWidget(host(const AppCardMenu(actions: [])));
    expect(find.byType(PopupMenuButton<AppCardMenuAction>), findsNothing);
  });

  testWidgets('Footer prioritario conserva acciones con texto ampliado', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        AppCard(
          header: header,
          actions: AppCardActions(
            navigationAction: AppCardQuickAction(
              icon: Icons.list,
              label: 'Ver detalles',
              onPressed: () => calls++,
            ),
            operationalAction: AppCardQuickAction(
              icon: Icons.add,
              label: 'Asignar',
              onPressed: () => calls++,
            ),
          ),
        ),
        scale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Ver detalles'));
    await tester.tap(find.text('Asignar'));
    expect(calls, 2);
  });
}
