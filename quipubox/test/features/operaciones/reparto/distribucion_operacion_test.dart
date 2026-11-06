import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/distribucion_operacion.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/reparto.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/widgets/distribucion_resumen_card.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/widgets/reparto_avance.dart';
import 'reparto_fixtures.dart' as f;

void main() {
  test(
    'Entrega directa asignada completa no equivale a calidades completas',
    () {
      final data = DistribucionOperacion(
        operacion: f.operation,
        cargas: [f.detail.copyWith(esReparto: false, cantidadClasificada: 60)],
        asignaciones: [
          const Reparto(
            id: 1,
            detalleId: 73,
            receptorId: 25,
            puestoId: 221,
            cantidad: 100,
          ),
        ],
      );
      expect(data.cargadas, 100);
      expect(data.asignadas, 100);
      expect(data.sinDestinatario, 0);
      expect(data.clasificadas, 60);
      expect(data.sinClasificar, 40);
      expect(data.desglosesPendientes, 1);
    },
  );
  test(
    'Una carga con exceso no oculta faltantes de otra y frutas no cuenta envíos',
    () {
      final data = DistribucionOperacion(
        operacion: f.operation,
        cargas: [
          f.detail.copyWith(cantidadClasificada: 150),
          f.detail.copyWith(id: 74, cantidadClasificada: 0),
        ],
        asignaciones: [
          const Reparto(id: 1, detalleId: 73, puestoId: 221, cantidad: 200),
        ],
      );
      expect(data.cargadas, 200);
      expect(data.productos, 1);
      expect(data.sinDestinatario, 100);
      expect(data.sinClasificar, 100);
      expect(data.excesoAsignacion, isTrue);
      expect(data.excesoClasificacion, isTrue);
    },
  );
  test(
    'Datos de clasificación omitidos no se convierten en cero inventado',
    () {
      const carga = f.detail;
      final unknown = DistribucionOperacion(
        operacion: f.operation,
        cargas: [
          carga,
          const DetalleCarga(
            id: 74,
            idClienteEmisor: 1,
            idFruta: 1,
            idTipoJaba: 1,
            cantidadJabas: 100,
          ),
        ],
        asignaciones: [],
      );
      expect(unknown.clasificadas, isNull);
      expect(unknown.sinClasificar, isNull);
    },
  );
  for (final dark in [false, true]) {
    testWidgets(
      'Barras independientes muestran 30% asignado y 60% clasificado; oscuro=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final data = DistribucionOperacion(
          operacion: f.operation,
          cargas: [f.detail.copyWith(cantidadClasificada: 60)],
          asignaciones: [
            const Reparto(
              id: 1,
              detalleId: 73,
              receptorId: 25,
              puestoId: 221,
              cantidad: 30,
            ),
          ],
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark : AppTheme.light,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DistribucionResumenCard(data: data),
                ),
              ),
            ),
          ),
        );
        expect(find.text('100 jabas cargadas'), findsOneWidget);
        expect(find.text('30/100'), findsOneWidget);
        expect(find.text('60/100'), findsOneWidget);
        expect(
          tester
              .widgetList<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator),
              )
              .map((b) => b.value),
          [.3, .6],
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RepartoAvance(
                label: 'Calidades',
                cantidad: null,
                total: 100,
              ),
            ),
          ),
        );
        expect(find.text('Por verificar'), findsOneWidget);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator),
              )
              .value,
          0,
        );
      },
    );
  }
}
