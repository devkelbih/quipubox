import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/presentation/widgets/carga_details_list.dart';
import 'package:quipubox/features/operaciones/carga/presentation/widgets/detalle_carga_row.dart';

List<int?> _ids(WidgetTester tester) => tester
    .widgetList<DetalleCargaRow>(find.byType(DetalleCargaRow))
    .map((row) => row.item.id)
    .toList();

void main() {
  testWidgets(
    'Reordenar permite cancelar, confirmar y conserva el orden tras refrescar datos',
    (tester) async {
      tester.view.physicalSize = const Size(400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final details = List.generate(
        3,
        (i) => DetalleCarga(
          id: i + 1,
          idClienteEmisor: 1,
          idFruta: 1,
          idTipoJaba: 1,
          cantidadJabas: 100,
          cantidadClasificada: [0, 40, 100][i],
          calidades: i == 0 ? [] : ['Primera'],
        ),
      );
      final operation = OperacionCarga(
        id: 44,
        idSedeOrigen: 1,
        idCamion: 1,
        fechaCarga: DateTime(2026),
        estado: 'en_curso',
      );
      Future<void> render(List<DetalleCarga> items) => tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CargaDetailsList(
              operation: operation,
              detalles: items,
              isBusy: false,
              isLoading: false,
              onRefresh: () async {},
              onAddDetalle: () {},
              onFinalizar: () {},
              onAddCalidad: (_) {},
              onEditDetalle: (_) {},
              onEditCalidad: (_, _) {},
              onDeleteDetalle: (_) {},
            ),
          ),
        ),
      );
      await render(details);
      await tester.pumpAndSettle();
      expect(find.text('Fruta #1 - Sin clasificar'), findsOneWidget);
      expect(find.text('Fruta #1 - Faltan 60 de 100'), findsOneWidget);
      expect(find.byIcon(Icons.drag_indicator), findsNothing);
      Future<void> start() async {
        await tester.tap(find.byTooltip('Opciones de lista'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Reordenar'));
        await tester.pumpAndSettle();
      }

      await start();
      expect(find.byIcon(Icons.drag_indicator), findsNWidgets(3));
      expect(find.byTooltip('Opciones de carga'), findsNothing);
      expect(find.textContaining('Este orden se mantiene'), findsOneWidget);
      // Arrastre real desde el agarre de la primera fila hasta la última.
      final handles = find.byTooltip('Arrastrar para reordenar');
      final gesture = await tester.startGesture(
        tester.getCenter(handles.first),
      );
      await tester.pump();
      await gesture.moveTo(
        tester.getCenter(handles.last) + const Offset(0, 25),
      );
      await tester.pump(const Duration(milliseconds: 400));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(_ids(tester), isNot([1, 2, 3]));
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(_ids(tester), [1, 2, 3]);
      await start();
      tester
          .widget<SliverReorderableList>(find.byType(SliverReorderableList))
          .onReorder(0, 3);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Listo'));
      await tester.pumpAndSettle();
      expect(_ids(tester), [2, 3, 1]);
      expect(details.map((d) => d.id), [1, 2, 3]);
      expect(find.byIcon(Icons.drag_indicator), findsNothing);
      await render(
        details.map((d) => d.copyWith(observaciones: 'Actualizado')).toList(),
      );
      await tester.pumpAndSettle();
      expect(_ids(tester), [2, 3, 1]);
      expect(tester.takeException(), isNull);
    },
  );
}
