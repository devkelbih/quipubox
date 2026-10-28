import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';

import 'carga_details_test.dart' as fixtures;

class _Repository extends fixtures.Repository {
  OperacionCarga? saved;

  @override
  Future<OperacionCarga> create(OperacionCarga operation) async {
    saved = operation;
    return operation;
  }

  @override
  Future<OperacionCarga> update(OperacionCarga operation) async {
    saved = operation;
    return operation;
  }
}

OperacionCarga _operation(DateTime date) => OperacionCarga(
  idSedeOrigen: 1,
  idCamion: 2,
  fechaCarga: date,
  horaCarga: '01:02:03',
);

void main() {
  test('Calcula la hora al guardar y descarta la hora recibida', () async {
    final repository = _Repository();
    final vm = fixtures.viewModel(repository);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    expect(await vm.create(_operation(today)), isTrue);
    final savedTime = repository.saved!.horaCarga!;
    final parts = savedTime.split(':').map(int.parse).toList();
    final savedAt = DateTime(
      today.year,
      today.month,
      today.day,
      parts[0],
      parts[1],
      parts[2],
    );
    expect(savedAt.isBefore(now.subtract(const Duration(seconds: 1))), isFalse);
    expect(savedAt.isAfter(DateTime.now()), isFalse);
  });

  for (final daysAgo in [1, 30]) {
    test('Fecha anterior de $daysAgo días elimina la hora recibida', () async {
      final repository = _Repository();
      final vm = fixtures.viewModel(repository);
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day - daysAgo);
      expect(await vm.create(_operation(date)), isTrue);
      expect(repository.saved!.fechaCarga, date);
      expect(repository.saved!.horaCarga, isNull);
    });
  }

  test('Rechaza mañana y expone el mensaje para el toast', () async {
    final repository = _Repository();
    final vm = fixtures.viewModel(repository);
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    expect(await vm.create(_operation(tomorrow)), isFalse);
    expect(repository.saved, isNull);
    expect(vm.errorMessage, 'La fecha de carga no puede ser futura.');
    expect(vm.isSaving, isFalse);
  });

  test('Editar conserva la fecha y la hora con segundos', () async {
    final repository = _Repository();
    final vm = fixtures.viewModel(repository);
    final operation = _operation(DateTime(2020, 1, 1)).copyWith(id: 1);
    expect(await vm.update(operation), isTrue);
    expect(repository.saved!.fechaCarga, operation.fechaCarga);
    expect(repository.saved!.horaCarga, '01:02:03');
  });
}
