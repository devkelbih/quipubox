import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operacion_carga_by_id.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/get_distribucion_operacion.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/viewmodels/reparto_operacion_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operaciones_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_detalles_operacion.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/get_repartos.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/viewmodels/reparto_list_viewmodel.dart';
import 'reparto_fixtures.dart' as f;
import 'reparto_ui_test.dart' show vmFor;

class _Ops implements GetOperacionesCargaUseCase {
  @override
  Future<List<OperacionCarga>> call({String? estado, DateTime? fecha}) async =>
      [f.operation, f.operation.copyWith(id: 45)];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Details implements GetDetallesOperacionUseCase {
  bool fail = false;
  @override
  Future<List<DetalleCarga>> call(int id) async {
    if (fail) throw const AppException('No se pudo actualizar la carga.');
    return id == 44
        ? [f.detail.copyWith(cantidadClasificada: 0)]
        : [f.detail.copyWith(id: 74, idOperacion: 45)];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Op implements GetOperacionCargaByIdUseCase {
  @override
  Future<OperacionCarga> call(int id) async => f.operation.copyWith(id: id);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('Listado solo consulta operaciones y conserva los filtros', () async {
    final vm = RepartoListViewModel(getOperaciones: _Ops());
    await vm.load();
    expect(vm.operaciones.length, 2);
    await vm.setFilters(estado: 'en_transito', fecha: DateTime(2026, 11, 2));
    expect(vm.estado, 'en_transito');
    expect(vm.fecha, DateTime(2026, 11, 2));
    vm.dispose();
  });
  test(
    'Incluye cargas sin calidades y no mezcla asignaciones entre operaciones',
    () async {
      final repo = f.Repository()
        ..items = [
          const Reparto(
            id: 1,
            detalleId: 73,
            operacionId: 44,
            receptorId: 25,
            puestoId: 221,
            cantidad: 100,
          ),
        ];
      final details = _Details();
      final vm = RepartoOperacionViewModel(
        GetDistribucionOperacionUseCase(
          getOperacion: _Op(),
          getCargas: details,
          getRepartos: GetRepartosUseCase(repo),
        ),
      );
      await vm.load(44);
      expect(vm.data!.cargas.single.cantidadClasificada, 0);
      expect(vm.data!.sinDestinatario, 0);
      expect(vm.data!.asignaciones.length, 1);
      await vm.load(45);
      expect(vm.data!.operacion.id, 45);
      expect(vm.data!.asignaciones, isEmpty);
      expect(vm.data!.cargas.single.id, 74);
      details.fail = true;
      await vm.load(45);
      expect(vm.errorMessage, contains('actualizar'));
      expect(vm.data!.cargas.single.id, 74);
      expect(vm.isLoading, isFalse);
      vm.dispose();
    },
  );
  test(
    'Valida saldos recientes, mantiene el contexto tras error y no escribe',
    () async {
      final repo = f.Repository();
      final loader = f.Loader(f.contextData());
      final vm = vmFor(repo, loader);
      await vm.load(44, 73);
      loader.data = f.contextData(
        items: [
          const Reparto(id: 1, detalleId: 73, puestoId: 221, cantidad: 100),
        ],
      );
      expect(await vm.assign([f.asignacion()]), isFalse);
      expect(vm.errorMessage, contains('superan'));
      expect(vm.data, isNotNull);
      expect(vm.isBusy, isFalse);
      expect(repo.calls, isEmpty);
      vm.dispose();
    },
  );
}
