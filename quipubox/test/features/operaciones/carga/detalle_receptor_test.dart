import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/data/models/detalle_carga_model.dart';
import 'package:quipubox/features/operaciones/carga/data/models/detalle_carga_request_model.dart';
import 'package:quipubox/features/operaciones/carga/presentation/widgets/detalle_carga_row.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';

Map<String, dynamic> _json() => {
  'id_detalle_carga': 73,
  'id_cliente_emisor': 1,
  'id_fruta': 1,
  'id_tipo_jaba': 1,
  'cantidad_jabas': 100,
  'es_reparto': false,
};

Map<String, dynamic> _reparto(int id, String nombre) => {
  'id_cliente_receptor': id,
  'clientes': {'id_cliente': id, 'nombres': nombre},
};

void main() {
  test('Lee un receptor singular y lo conserva al copiar la entidad', () {
    final model = DetalleCargaModel.fromJson({
      ..._json(),
      'items_reparto': [_reparto(2, 'Carla'), _reparto(2, 'Carla')],
    });
    final detalle = model.toEntity();
    expect(detalle.clienteReceptor?.nombreCompleto, 'Carla');
    expect(detalle.copyWith(cantidadJabas: 50).clienteReceptor?.id, 2);
    expect(
      DetalleCargaModel.fromEntity(detalle).toEntity().clienteReceptor?.id,
      2,
    );
    expect(
      DetalleCargaRequestModel.fromEntity(
        detalle,
      ).toCreateJson().containsKey('id_cliente_receptor'),
      isFalse,
    );
  });

  test('Lee la relación singular que devuelve la creación', () {
    final detalle = DetalleCargaModel.fromJson({
      ..._json(),
      'item_reparto': _reparto(2, 'Carla'),
    }).toEntity();
    expect(detalle.clienteReceptor?.id, 2);
  });

  test('Sin receptor o con varios distintos no elige un nombre arbitrario', () {
    expect(
      DetalleCargaModel.fromJson(_json()).toEntity().clienteReceptor,
      isNull,
    );
    final detalle = DetalleCargaModel.fromJson({
      ..._json(),
      'items_reparto': [_reparto(2, 'Carla'), _reparto(3, 'Pedro')],
    }).toEntity();
    expect(detalle.clienteReceptor, isNull);
  });

  for (final dark in [false, true]) {
    testWidgets(
      'Receptor o Reparto, retorno y columnas alineadas; oscuro=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark : AppTheme.light,
            home: const Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DetalleCargaRow(
                        item: DetalleCarga(
                          idClienteEmisor: 1,
                          idFruta: 1,
                          idTipoJaba: 1,
                          cantidadJabas: 5,
                          esReparto: true,
                          requiereRetornoJabas: true,
                          clienteReceptor: Cliente(id: 2, nombres: 'Carla'),
                        ),
                      ),
                      DetalleCargaRow(
                        item: DetalleCarga(
                          idClienteEmisor: 1,
                          idFruta: 1,
                          idTipoJaba: 1,
                          cantidadJabas: 1000,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        expect(find.text('E: No asignado - R: Carla'), findsOneWidget);
        expect(find.text('E: No asignado - Reparto'), findsOneWidget);
        expect(find.byTooltip('Requiere retorno de jabas: Sí'), findsOneWidget);
        expect(find.byTooltip('Requiere retorno de jabas: No'), findsOneWidget);
        final titles = find.text('Fruta #1 - Sin clasificar');
        expect(
          tester.getTopLeft(titles.first).dx,
          tester.getTopLeft(titles.last).dx,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
