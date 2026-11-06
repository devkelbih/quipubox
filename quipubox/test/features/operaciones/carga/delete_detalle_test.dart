import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/core/ui/feedback/delete_confirmation_dialog.dart';
import 'package:quipubox/features/operaciones/carga/data/datasources/operacion_carga_remote_data_source.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/presentation/screens/carga_detail_screen.dart';
import 'package:quipubox/features/operaciones/carga/presentation/viewmodels/carga_viewmodel.dart';

import 'carga_details_test.dart' as fixtures;

class _Repository extends fixtures.Repository {
  int deleteRequests = 0;
  int? deletedId;
  bool fails = false;
  Completer<void>? pending;

  @override
  Future<void> deleteDetalle(int detalleId) async {
    deleteRequests++;
    deletedId = detalleId;
    if (fails) throw const AppException('No se pudo eliminar este detalle.');
    if (pending != null) await pending!.future;
  }
}

OperacionCarga _operation([String estado = 'en_curso']) => OperacionCarga(
  id: 44,
  idSedeOrigen: 1,
  idCamion: 2,
  fechaCarga: DateTime(2026),
  estado: estado,
  observaciones: 'Conservar cabecera',
);

class _Api extends ApiClient {
  String? path;
  @override
  Future<dynamic> delete(String path) async {
    this.path = path;
    return null;
  }
}

void main() {
  test(
    'DELETE usa la ruta existente y no requiere parsear el objeto eliminado',
    () async {
      final api = _Api();
      await OperacionCargaRemoteDataSource(apiClient: api).deleteDetalle(73);
      expect(api.path, '/detalle-carga/73');
    },
  );

  testWidgets(
    'Cancelar no elimina; confirmar espera a la API y conserva la cabecera',
    (tester) async {
      final repository = _Repository()..pending = Completer();
      final vm = fixtures.viewModel(repository);
      final operation = _operation();
      await tester.pumpWidget(
        ChangeNotifierProvider<CargaViewModel>.value(
          value: vm,
          child: MaterialApp(
            home: CargaDetailScreen(operationId: 44, operation: operation),
          ),
        ),
      );
      await tester.pumpAndSettle();

      Future<void> openDelete() async {
        await tester.tap(find.byTooltip('Opciones de carga'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Eliminar detalle'));
        await tester.pumpAndSettle();
        expect(find.byType(DeleteConfirmationDialog), findsOneWidget);
        expect(find.textContaining('20 jabas'), findsOneWidget);
      }

      await openDelete();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(repository.deleteRequests, 0);
      expect(vm.detalles, hasLength(1));

      await openDelete();
      await tester.tap(find.text('Eliminar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(repository.deleteRequests, 1);
      expect(vm.isDeleting, isTrue);
      expect(vm.detalles, hasLength(1));
      expect(await vm.eliminarDetalle(operacionId: 44, detalleId: 10), isFalse);
      expect(repository.deleteRequests, 1);

      repository.pending!.complete();
      await tester.pumpAndSettle();
      expect(repository.deletedId, 10);
      expect(vm.detalles, isEmpty);
      expect(vm.selected!.detalles, isEmpty);
      expect(vm.selected!.observaciones, 'Conservar cabecera');
      expect(repository.headerRequests, 0);
      expect(repository.detailsRequests, 1);
      expect(vm.isDeleting, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      vm.dispose();
    },
  );

  test('Un error de API conserva el detalle y expone su mensaje', () async {
    final repository = _Repository()..fails = true;
    final vm = fixtures.viewModel(repository);
    await vm.loadDetalles(_operation());
    expect(await vm.eliminarDetalle(operacionId: 44, detalleId: 10), isFalse);
    expect(vm.detalles, hasLength(1));
    expect(vm.errorMessage, 'No se pudo eliminar este detalle.');
    expect(vm.isDeleting, isFalse);
    vm.dispose();
  });

  for (final estado in ['repartiendo', 'cancelada']) {
    test('Bloquea la eliminación si la operación está $estado', () async {
      final repository = _Repository();
      final vm = fixtures.viewModel(repository);
      await vm.loadDetalles(_operation(estado));
      expect(await vm.eliminarDetalle(operacionId: 44, detalleId: 10), isFalse);
      expect(repository.deleteRequests, 0);
      expect(vm.detalles, hasLength(1));
      vm.dispose();
    });
  }

  test('No elimina un detalle ajeno a la operación seleccionada', () async {
    final repository = _Repository();
    final vm = fixtures.viewModel(repository);
    await vm.loadDetalles(_operation());
    expect(await vm.eliminarDetalle(operacionId: 45, detalleId: 10), isFalse);
    expect(await vm.eliminarDetalle(operacionId: 44, detalleId: 99), isFalse);
    expect(repository.deleteRequests, 0);
    expect(vm.detalles, hasLength(1));
    vm.dispose();
  });
}
