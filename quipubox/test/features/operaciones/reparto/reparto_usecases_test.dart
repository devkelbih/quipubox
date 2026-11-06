import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/save_asignaciones_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/update_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/save_linea_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/delete_reparto.dart';
import 'reparto_fixtures.dart' as f;

void main() {
  late f.Repository repo;
  late f.Loader loader;
  late SaveAsignacionesRepartoUseCase save;
  setUp(() {
    repo = f.Repository();
    loader = f.Loader(f.contextData());
    save = SaveAsignacionesRepartoUseCase(
      repository: repo,
      getContexto: loader,
      currentSession: f.Session(),
    );
  });
  test('Receptor único por calidades usa el endpoint individual', () async {
    await save(44, 73, [f.asignacion()]);
    expect(repo.calls, ['calidades']);
    expect(repo.saved!.single.idEmpresa, 1);
    expect(repo.saved!.single.lineas.every((l) => l.idEmpresa == 1), isTrue);
    expect(loader.requests, 1);
  });
  test(
    'Varios receptores se envían juntos y descuentan cada calidad globalmente',
    () async {
      await save(44, 73, [
        f.asignacion(),
        f.asignacion(
          cantidad: 70,
          lineas: const [
            RepartoLinea(idCalidadCarga: 101, cantidad: 40),
            RepartoLinea(idCalidadCarga: 102, cantidad: 30),
          ],
        ),
      ]);
      expect(repo.calls, ['multiple']);
      expect(repo.saved!.length, 2);
    },
  );
  test('Reserva sin desglose usa el endpoint simple', () async {
    await save(44, 73, [f.asignacion(cantidad: 100, lineas: [])]);
    expect(repo.calls, ['simple']);
  });
  test('Rechaza exceder calidad aunque el total cargado alcance', () async {
    await expectLater(
      save(44, 73, [
        f.asignacion(
          cantidad: 61,
          lineas: const [RepartoLinea(idCalidadCarga: 101, cantidad: 61)],
        ),
      ]),
      throwsA(isA<AppException>()),
    );
    expect(repo.calls, isEmpty);
  });
  test(
    'Rechaza exceso agregado entre borradores de varios receptores',
    () async {
      await expectLater(
        save(44, 73, [
          f.asignacion(
            cantidad: 40,
            lineas: const [RepartoLinea(idCalidadCarga: 101, cantidad: 40)],
          ),
          f.asignacion(
            cantidad: 30,
            lineas: const [RepartoLinea(idCalidadCarga: 101, cantidad: 30)],
          ),
        ]),
        throwsA(isA<AppException>()),
      );
      expect(repo.calls, isEmpty);
    },
  );
  test(
    'Rechaza calidad repetida, cantidad vacía, precio inválido y receptor incorrecto',
    () async {
      for (final invalid in [
        f.asignacion(cantidad: 0, lineas: []),
        f.asignacion(receptor: 99),
        f.asignacion(
          cantidad: 2,
          lineas: const [
            RepartoLinea(idCalidadCarga: 101, cantidad: 1),
            RepartoLinea(idCalidadCarga: 101, cantidad: 1),
          ],
        ),
        f.asignacion(
          cantidad: 1,
          lineas: const [RepartoLinea(idCalidadCarga: 999, cantidad: 1)],
        ),
        f.asignacion(
          cantidad: 1,
          lineas: const [
            RepartoLinea(idCalidadCarga: 101, cantidad: 1, precio: -1),
          ],
        ),
      ]) {
        await expectLater(
          save(44, 73, [invalid]),
          throwsA(isA<AppException>()),
        );
      }
      expect(repo.calls, isEmpty);
    },
  );
  const item = Reparto(
    id: 1,
    detalleId: 73,
    receptorId: 25,
    puestoId: 221,
    cantidad: 100,
    lineas: [RepartoLinea(id: 11, idCalidadCarga: 101, cantidad: 20)],
  );
  test('Entrega directa existente no se duplica', () async {
    loader.data = f.contextData(directa: true, items: [item]);
    await expectLater(
      save(44, 73, [f.asignacion()]),
      throwsA(isA<AppException>()),
    );
    expect(repo.calls, isEmpty);
  });
  test(
    'Respeta cantidades reservadas sin desglose y estado de operación',
    () async {
      loader.data = f.contextData(items: [item]);
      await expectLater(
        save(44, 73, [f.asignacion()]),
        throwsA(isA<AppException>()),
      );
      loader.data = f.contextData(estado: 'completado');
      await expectLater(
        save(44, 73, [f.asignacion()]),
        throwsA(isA<AppException>()),
      );
    },
  );
  test('Editar línea excluye su cantidad anterior al calcular saldo', () async {
    loader.data = f.contextData(items: [item]);
    final line = SaveLineaRepartoUseCase(
      repository: repo,
      getContexto: loader,
      currentSession: f.Session(),
    );
    await line(
      44,
      73,
      1,
      const RepartoLinea(id: 11, idCalidadCarga: 101, cantidad: 60),
    );
    expect(repo.calls, ['updateLinea']);
    await expectLater(
      line(
        44,
        73,
        1,
        const RepartoLinea(id: 11, idCalidadCarga: 101, cantidad: 61),
      ),
      throwsA(isA<AppException>()),
    );
  });
  test(
    'Completa el ítem directo existente sin crear otro y bloquea duplicados',
    () async {
      loader.data = f.contextData(directa: true, items: [item]);
      final line = SaveLineaRepartoUseCase(
        repository: repo,
        getContexto: loader,
        currentSession: f.Session(),
      );
      await line(
        44,
        73,
        1,
        const RepartoLinea(idCalidadCarga: 102, cantidad: 40),
      );
      expect(repo.calls, ['addLinea']);
      await expectLater(
        line(44, 73, 1, const RepartoLinea(idCalidadCarga: 101, cantidad: 1)),
        throwsA(isA<AppException>()),
      );
    },
  );
  test('No permite reducir encabezado por debajo del desglose', () async {
    loader.data = f.contextData(items: [item]);
    final update = UpdateRepartoUseCase(
      repository: repo,
      getContexto: loader,
      currentSession: f.Session(),
    );
    await expectLater(
      update(44, 73, 1, f.asignacion(cantidad: 19, lineas: [])),
      throwsA(isA<AppException>()),
    );
    await update(44, 73, 1, f.asignacion(cantidad: 30, lineas: []));
    expect(repo.calls, ['update']);
  });
  test(
    'Eliminación usa el ID de línea y no borra implícitamente otras líneas',
    () async {
      loader.data = f.contextData(items: [item]);
      final delete = DeleteRepartoUseCase(
        repository: repo,
        getContexto: loader,
        currentSession: f.Session(),
      );
      await expectLater(delete(44, 73, 1), throwsA(isA<AppException>()));
      await delete(44, 73, 1, lineaId: 11);
      expect(repo.calls, ['deleteLinea']);
    },
  );
  test('Protege asignaciones que ya tienen entregas', () async {
    loader.data = f.contextData(
      items: [
        const Reparto(
          id: 2,
          detalleId: 73,
          puestoId: 221,
          cantidad: 10,
          tieneEntregas: true,
        ),
      ],
    );
    final delete = DeleteRepartoUseCase(
      repository: repo,
      getContexto: loader,
      currentSession: f.Session(),
    );
    await expectLater(delete(44, 73, 2), throwsA(isA<AppException>()));
    expect(repo.calls, isEmpty);
  });
}
