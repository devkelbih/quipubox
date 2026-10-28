import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/operaciones/carga/data/models/detalle_carga_model.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/repositories/operacion_carga_repository.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operaciones_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operacion_carga_by_id.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_detalles_operacion.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/create_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/update_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/change_estado_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/cancelar_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/finalizar_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/generar_guias_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/presentation/viewmodels/carga_viewmodel.dart';
import 'package:quipubox/features/operaciones/carga/presentation/screens/carga_detail_screen.dart';

class Session implements CurrentSession {
  @override
  int get currentCompanyId => 1;
  @override
  int get currentUserId => 1;
  @override
  int get currentSedeId => 1;
}

class Repository implements OperacionCargaRepository {
  int headerRequests = 0;
  int detailsRequests = 0;
  @override
  Future<OperacionCarga> getById(int id) async {
    headerRequests++;
    throw StateError('No recargar la cabecera');
  }

  @override
  Future<List<DetalleCarga>> getDetalles(int id) async {
    detailsRequests++;
    return [
      DetalleCargaModel.fromJson({
        'id_detalle_carga': 10,
        'id_operacion': id,
        'id_cliente_emisor': 1,
        'id_fruta': 2,
        'id_tipo_jaba': 3,
        'cantidad_jabas': 20,
        'detalle_carga_calidades': [
          {
            'calidades': {'nombre': 'Primera'},
          },
          {
            'calidades': {'nombre': 'Segunda'},
          },
        ],
        'items_reparto': [
          {
            'clientes': {'nombres': 'Ana', 'apellidos': 'Pérez'},
          },
          {
            'clientes': {'nombres': 'Ana', 'apellidos': 'Pérez'},
          },
        ],
      }).toEntity(),
    ];
  }

  @override
  Future<OperacionCarga> finalizar(int id) async => OperacionCarga(
    id: id,
    idSedeOrigen: 1,
    idCamion: 2,
    fechaCarga: DateTime(2026),
    estado: 'repartiendo',
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

CargaViewModel viewModel(Repository r) => CargaViewModel(
  getOperacionesUseCase: GetOperacionesCargaUseCase(repository: r),
  getOperacionByIdUseCase: GetOperacionCargaByIdUseCase(repository: r),
  getDetallesUseCase: GetDetallesOperacionUseCase(repository: r),
  createOperacionUseCase: CreateOperacionCargaUseCase(
    repository: r,
    currentSession: Session(),
  ),
  updateOperacionUseCase: UpdateOperacionCargaUseCase(
    repository: r,
    currentSession: Session(),
  ),
  changeEstadoUseCase: ChangeEstadoOperacionCargaUseCase(
    repository: r,
    currentSession: Session(),
  ),
  cancelarUseCase: CancelarOperacionCargaUseCase(
    repository: r,
    currentSession: Session(),
  ),
  finalizarUseCase: FinalizarOperacionCargaUseCase(
    repository: r,
    currentSession: Session(),
  ),
  generarGuiasUseCase: GenerarGuiasOperacionCargaUseCase(
    repository: r,
    currentSession: Session(),
  ),
);
void main() {
  testWidgets('Reutiliza cabecera y muestra lista con calidades y receptores', (
    tester,
  ) async {
    final repository = Repository();
    final vm = viewModel(repository);
    final operation = OperacionCarga(
      id: 1,
      idSedeOrigen: 1,
      idCamion: 2,
      fechaCarga: DateTime(2026),
      estado: 'en_curso',
      observaciones: 'Conservar cabecera',
    );
    vm.items = [operation];
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: vm,
        child: MaterialApp(
          home: CargaDetailScreen(operationId: 1, operation: operation),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(repository.headerRequests, 0);
    expect(repository.detailsRequests, 1);
    expect(find.text('Conservar cabecera'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.textContaining('Primera, Segunda'), findsOneWidget);
    expect(find.textContaining('Ana Pérez'), findsOneWidget);
    expect(vm.detalles.single.clientesReceptores, ['Ana Pérez']);
    expect(find.text('Agregar'), findsOneWidget);
    await tester.ensureVisible(find.text('Finalizar operación'));
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Finalizar operación'),
          )
          .onPressed,
      isNotNull,
    );
    await vm.finalizar(1);
    await tester.pumpAndSettle();
    expect(vm.selected!.estado, 'repartiendo');
    expect(vm.selected!.observaciones, 'Conservar cabecera');
    expect(repository.headerRequests, 0);
    expect(find.text('Finalizar operación'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    vm.dispose();
  });
}
