import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/catalogos/frutas/domain/entities/fruta.dart';
import 'package:quipubox/features/catalogos/frutas/domain/repositories/fruta_repository.dart';
import 'package:quipubox/features/catalogos/frutas/domain/usecases/get_frutas.dart';
import 'package:quipubox/features/catalogos/frutas/domain/usecases/create_fruta.dart';
import 'package:quipubox/features/catalogos/frutas/domain/usecases/update_fruta.dart';
import 'package:quipubox/features/catalogos/frutas/domain/usecases/change_fruta_status.dart';
import 'package:quipubox/features/catalogos/frutas/presentation/viewmodels/frutas_viewmodel.dart';
import 'package:quipubox/features/catalogos/variedades/domain/entities/variedad.dart';
import 'package:quipubox/features/catalogos/variedades/domain/entities/variedad_resumen.dart';
import 'package:quipubox/features/catalogos/variedades/domain/repositories/variedad_repository.dart';
import 'package:quipubox/features/catalogos/variedades/domain/usecases/create_variedad.dart';
import 'package:quipubox/features/catalogos/variedades/domain/usecases/update_variedad.dart';
import 'package:quipubox/features/catalogos/variedades/domain/usecases/get_variedades.dart';
import 'package:quipubox/features/catalogos/variedades/domain/usecases/change_variedad_status.dart';
import 'package:quipubox/features/catalogos/variedades/presentation/viewmodels/variedades_viewmodel.dart';

class Session implements CurrentSession {
  @override
  int get currentCompanyId => 1;
  @override
  int get currentUserId => 1;
  @override
  int get currentSedeId => 1;
}

class NoRequests implements FrutaRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('No debe consultarse la API de frutas');
}

class SavedVariedad implements VariedadRepository {
  @override
  Future<Variedad> create(Variedad value) async =>
      value.copyWith(id: 99, nombre: 'Kent confirmado');
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

FrutaViewModel frutasVm() {
  final repo = NoRequests();
  return FrutaViewModel(
    getItemsUseCase: GetFrutasUseCase(repository: repo),
    createUseCase: CreateFrutaUseCase(
      repository: repo,
      currentSession: Session(),
    ),
    updateUseCase: UpdateFrutaUseCase(repository: repo),
    changeStatusUseCase: ChangeFrutaStatusUseCase(repository: repo),
  );
}

void main() {
  test(
    'Registrar devuelve la variedad confirmada y actualiza únicamente su fruta sin consultas',
    () async {
      final repo = SavedVariedad();
      final variedades = VariedadViewModel(
        getItemsUseCase: GetVariedadesUseCase(repository: repo),
        createUseCase: CreateVariedadUseCase(
          repository: repo,
          currentSession: Session(),
        ),
        updateUseCase: UpdateVariedadUseCase(repository: repo),
        changeStatusUseCase: ChangeVariedadStatusUseCase(repository: repo),
      );
      final frutas = frutasVm();
      const otra = Fruta(id: 2, nombre: 'Palta');
      frutas.items = [
        const Fruta(
          id: 1,
          nombre: 'Mango',
          descripcion: 'Conservar',
          variedades: [
            VariedadResumen(id: 10, nombre: 'Anterior', estado: true),
          ],
        ),
        otra,
      ];
      final saved = await variedades.createWithResult(
        const Variedad(idFruta: 1, nombre: 'Kent'),
      );
      expect(saved!.id, 99);
      frutas.upsertVariedad(saved);
      expect(frutas.items.first.nombre, 'Mango');
      expect(frutas.items.first.descripcion, 'Conservar');
      expect(frutas.items.first.totalVariedades, 2);
      expect(frutas.items.first.variedades!.last.nombre, 'Kent confirmado');
      expect(identical(frutas.items.last, otra), isTrue);
      expect(frutas.isLoading, isFalse);
      frutas.upsertVariedad(saved.copyWith(nombre: 'Kent actualizado'));
      expect(frutas.items.first.totalVariedades, 2);
      expect(frutas.items.first.variedades!.last.nombre, 'Kent actualizado');
      variedades.dispose();
      frutas.dispose();
    },
  );
  test(
    'Usa la fruta seleccionada en el resultado e ignora IDs no disponibles',
    () {
      final vm = frutasVm();
      vm.items = [
        const Fruta(id: 1, nombre: 'Mango'),
        const Fruta(id: 2, nombre: 'Palta'),
      ];
      vm.upsertVariedad(const Variedad(id: 3, idFruta: 2, nombre: 'Hass'));
      expect(vm.items.first.totalVariedades, 0);
      expect(vm.items.last.totalVariedades, 1);
      vm.upsertVariedad(const Variedad(id: 4, idFruta: 999, nombre: 'Otra'));
      vm.upsertVariedad(const Variedad(idFruta: 1, nombre: 'Sin guardar'));
      expect(vm.items.first.totalVariedades, 0);
      expect(vm.items.last.totalVariedades, 1);
      vm.dispose();
    },
  );
}
