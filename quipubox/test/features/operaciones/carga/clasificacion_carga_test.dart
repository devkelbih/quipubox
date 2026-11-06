import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/theme/app_colors.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/features/operaciones/carga/data/models/detalle_carga_model.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/presentation/widgets/detalle_carga_row.dart';

void main() {
  test(
    'Lee cantidades numéricas o de texto y las conserva en entidad y copia',
    () {
      final item = DetalleCargaModel.fromJson({
        'id_cliente_emisor': 1,
        'id_fruta': 2,
        'id_tipo_jaba': 3,
        'cantidad_jabas': 100,
        'detalle_carga_calidades': [
          {
            'cantidad': 30,
            'calidades': {'nombre': 'Primera'},
          },
          {
            'cantidad': '70',
            'calidades': {'nombre': 'Segunda'},
          },
        ],
      }).toEntity();
      expect(item.cantidadClasificada, 100);
      expect(item.calidades, ['Primera', 'Segunda']);
      expect(item.copyWith(cantidadJabas: 120).cantidadClasificada, 100);
      expect(
        DetalleCargaModel.fromEntity(item).toEntity().cantidadClasificada,
        100,
      );
    },
  );

  test('Distingue cero registrado de cantidades omitidas en la respuesta', () {
    final json = {
      'id_cliente_emisor': 1,
      'id_fruta': 2,
      'id_tipo_jaba': 3,
      'cantidad_jabas': 100,
    };
    expect(DetalleCargaModel.fromJson(json).cantidadClasificada, isNull);
    expect(
      DetalleCargaModel.fromJson({
        ...json,
        'detalle_carga_calidades': [],
      }).cantidadClasificada,
      0,
    );
    expect(
      DetalleCargaModel.fromJson({
        ...json,
        'detalle_carga_calidades': [
          {
            'calidades': {'nombre': 'Primera'},
          },
        ],
      }).cantidadClasificada,
      isNull,
    );
  });

  for (final dark in [false, true]) {
    testWidgets(
      'Estado visible en cantidad e icono, sin ampliar la fila; oscuro=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        for (final classified in [0, 40, 100, 120]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: dark ? AppTheme.dark : AppTheme.light,
              home: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DetalleCargaRow(
                    item: DetalleCarga(
                      idClienteEmisor: 1,
                      idFruta: 2,
                      idTipoJaba: 3,
                      cantidadJabas: 100,
                      cantidadClasificada: classified,
                      calidades: classified == 0 ? [] : ['Primera'],
                    ),
                  ),
                ),
              ),
            ),
          );
          final error = classified == 0 || classified > 100;
          final color = error
              ? (dark ? AppTheme.dark : AppTheme.light).colorScheme.error
              : classified == 100
              ? AppColors.success
              : AppColors.warning;
          expect(tester.widget<Text>(find.text('100')).style!.color, color);
          expect(
            find.byIcon(
              error
                  ? Icons.error_outline_rounded
                  : classified == 100
                  ? Icons.check_circle_outline_rounded
                  : Icons.timelapse_rounded,
            ),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
}
