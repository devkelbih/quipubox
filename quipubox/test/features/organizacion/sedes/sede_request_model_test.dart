import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/features/organizacion/sedes/data/models/sede_request_model.dart';
import 'package:quipubox/features/organizacion/sedes/domain/entities/sede.dart';
import 'package:quipubox/features/organizacion/sedes/domain/enums/tipo_sede.dart';

void main() {
  for (final value in [null, '', '   ']) {
    test('Actualizar envía borrado explícito para campos vacíos: $value', () {
      final request = SedeRequestModel.fromEntity(
        Sede(
          id: 1,
          nombre: 'Sede',
          tipoSede: TipoSede.origen,
          direccion: value,
          ciudad: value,
          departamento: value,
        ),
      );
      final body = request.toUpdateJson();
      for (final field in ['direccion', 'ciudad', 'departamento']) {
        expect(body.containsKey(field), isTrue);
        expect(body[field], '');
      }
    });
  }

  test('Actualizar limpia dirección sin borrar ciudad ni departamento', () {
    final body = SedeRequestModel.fromEntity(
      const Sede(
        id: 1,
        nombre: 'Cañete',
        tipoSede: TipoSede.origen,
        direccion: '',
        ciudad: '  Cañete  ',
        departamento: ' Lima ',
      ),
    ).toUpdateJson();
    expect(body['direccion'], '');
    expect(body['ciudad'], 'Cañete');
    expect(body['departamento'], 'Lima');
    expect(body['nombre'], 'Cañete');
    expect(body['tipo_sede'], 'origen');
  });

  test('Crear conserva la omisión de campos opcionales vacíos', () {
    final body = SedeRequestModel.fromEntity(
      const Sede(
        idEmpresa: 1,
        nombre: 'Sede',
        tipoSede: TipoSede.destino,
        direccion: '',
        ciudad: '   ',
      ),
    ).toCreateJson();
    expect(body.containsKey('direccion'), isFalse);
    expect(body.containsKey('ciudad'), isFalse);
    expect(body.containsKey('departamento'), isFalse);
    expect(body['id_empresa'], 1);
  });
}
