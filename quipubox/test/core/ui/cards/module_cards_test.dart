import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/features/catalogos/calidades/domain/entities/calidad.dart';
import 'package:quipubox/features/catalogos/calidades/presentation/widgets/calidad_card.dart';
import 'package:quipubox/features/catalogos/camiones/domain/entities/camion.dart';
import 'package:quipubox/features/catalogos/camiones/presentation/widgets/camion_card.dart';
import 'package:quipubox/features/catalogos/frutas/domain/entities/fruta.dart';
import 'package:quipubox/features/catalogos/frutas/presentation/widgets/fruta_card.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/entities/tipos_jaba.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/enums/tipo_material_jaba.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/presentation/widgets/tipo_jaba_card.dart';
import 'package:quipubox/features/catalogos/variedades/domain/entities/variedad.dart';
import 'package:quipubox/features/catalogos/variedades/domain/entities/variedad_resumen.dart';
import 'package:quipubox/features/operaciones/carga/domain/enums/estado_operacion_carga.dart';
import 'package:quipubox/features/catalogos/variedades/presentation/widgets/variedad_card.dart';
import 'package:quipubox/features/organizacion/sedes/domain/entities/sede.dart';
import 'package:quipubox/features/organizacion/sedes/domain/enums/tipo_sede.dart';
import 'package:quipubox/features/organizacion/sedes/presentation/widgets/sede_card.dart';
import 'package:quipubox/features/organizacion/puestos/domain/entities/puesto.dart';
import 'package:quipubox/features/organizacion/puestos/presentation/widgets/puesto_card.dart';
import 'package:quipubox/features/organizacion/lugares_operativos/domain/entities/lugar_operativo.dart';
import 'package:quipubox/features/organizacion/lugares_operativos/domain/enums/lugar_operativo_tipos.dart';
import 'package:quipubox/features/organizacion/lugares_operativos/presentation/widgets/lugar_operativo_card.dart';
import 'package:quipubox/features/organizacion/usuarios/domain/entities/usuario.dart';
import 'package:quipubox/features/organizacion/usuarios/presentation/widgets/usuario_card.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/organizacion/clientes/presentation/widgets/cliente_card.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/presentation/widgets/carga_card.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';

Widget host(Widget card, {bool dark = false, double scale = 1}) => MaterialApp(
  theme: dark ? AppTheme.dark : AppTheme.light,
  home: Scaffold(
    body: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: SingleChildScrollView(child: SizedBox(width: 360, child: card)),
    ),
  ),
);

void main() {
  testWidgets('Frutas navega a variedades y respeta la disponibilidad', (
    tester,
  ) async {
    var calls = 0;
    var registrations = 0;
    for (final hasVarieties in [false, true]) {
      await tester.pumpWidget(
        host(
          FrutaCard(
            item: Fruta(
              nombre: 'Mango',
              variedades: hasVarieties
                  ? const [VariedadResumen(id: 1, nombre: 'Kent', estado: true)]
                  : const [],
            ),
            onEdit: () {},
            onChangeStatus: () {},
            onViewVariedades: () => calls++,
            onRegisterVariedad: () => registrations++,
          ),
        ),
      );
      expect(
        find.text('Ver variedades'),
        hasVarieties ? findsOneWidget : findsNothing,
      );
      if (hasVarieties) await tester.tap(find.text('Ver variedades'));
      await tester.tap(find.text('Registrar variedad'));
    }
    expect(calls, 1);
    expect(registrations, 2);
  });
  for (final active in [true, false]) {
    for (final dark in [true, false]) {
      testWidgets('Cards administrativas: activo=$active oscuro=$dark', (
        tester,
      ) async {
        var edits = 0;
        var changes = 0;
        void edit() => edits++;
        void change() => changes++;
        final cards = <Widget>[
          CalidadCard(
            item: Calidad(nombre: 'Calidad', estado: active),
            onEdit: edit,
            onChangeStatus: change,
          ),
          CamionCard(
            item: Camion(placa: 'ABC-123', estado: active),
            onEdit: edit,
            onChangeStatus: change,
          ),
          FrutaCard(
            item: Fruta(nombre: 'Fruta', estado: active),
            onEdit: edit,
            onChangeStatus: change,
          ),
          TipoJabaCard(
            item: TiposJaba(
              nombre: 'Jaba',
              tipoMaterial: TipoMaterialJaba.values.first,
              estado: active,
            ),
            onEdit: edit,
            onChangeStatus: change,
          ),
          VariedadCard(
            item: Variedad(nombre: 'Variedad', idFruta: 1, estado: active),
            onEdit: edit,
            onChangeStatus: change,
          ),
          SedeCard(
            item: Sede(
              nombre: 'Sede',
              tipoSede: TipoSede.origen,
              estado: active,
            ),
            onEdit: edit,
            onChangeStatus: change,
          ),
          PuestoCard(
            item: Puesto(numeroPuesto: '1', idLugar: 1, estado: active),
            onEdit: edit,
            onChangeStatus: change,
          ),
          LugarOperativoCard(
            item: LugarOperativo(
              nombre: 'Lugar',
              idSede: 1,
              tipoLugar: LugarOperativoTipos.values.first,
              estado: active,
            ),
            onEdit: edit,
            onChangeStatus: change,
          ),
          UsuarioCard(
            item: Usuario(
              nombres: 'Usuario',
              email: 'a@b.com',
              idSede: 1,
              roles: const [],
              estado: active,
            ),
            onEdit: edit,
            onChangeStatus: change,
            onManageRoles: () {},
          ),
          ClienteCard(
            item: Cliente(nombres: 'Cliente', estado: active),
            onEdit: edit,
            onChangeStatus: change,
          ),
        ];
        for (final card in cards) {
          await tester.pumpWidget(host(card, dark: dark, scale: 1.5));
          expect(tester.takeException(), isNull, reason: '${card.runtimeType}');
          expect(find.text('Editar'), findsNothing);
          expect(find.text('Desactivar'), findsNothing);
          expect(find.text('Activar'), findsNothing);
          await tester.tap(find.byTooltip('Más acciones'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Editar'));
          await tester.pumpAndSettle();
          await tester.tap(find.byTooltip('Más acciones'));
          await tester.pumpAndSettle();
          await tester.tap(find.text(active ? 'Desactivar' : 'Activar'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        expect(edits, cards.length);
        expect(changes, cards.length);
      });
    }
  }

  testWidgets('Clientes y usuarios mantienen sus accesos de gestión', (
    tester,
  ) async {
    var sedes = 0;
    var puestos = 0;
    var roles = 0;
    await tester.pumpWidget(
      host(
        ClienteCard(
          item: const Cliente(nombres: 'Cliente'),
          onManageSedes: () => sedes++,
          onManagePuestos: () => puestos++,
        ),
      ),
    );
    expect(find.text('Gestionar sedes'), findsNothing);
    await tester.tap(find.byTooltip('Más acciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gestionar sedes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Más acciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gestionar puestos'));
    await tester.pumpAndSettle();
    expect(sedes, 1);
    expect(puestos, 1);
    await tester.pumpWidget(
      host(
        UsuarioCard(
          item: const Usuario(
            nombres: 'Usuario',
            email: 'a@b.com',
            idSede: 1,
            roles: [],
          ),
          onEdit: () {},
          onChangeStatus: () {},
          onManageRoles: () => roles++,
        ),
      ),
    );
    expect(find.text('Gestionar roles'), findsNothing);
    await tester.tap(find.byTooltip('Más acciones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gestionar roles'));
    await tester.pumpAndSettle();
    expect(roles, 1);
  });

  testWidgets(
    'Carga conserva navegación y restricciones de edición/asignación',
    (tester) async {
      var opens = 0;
      var assignments = 0;
      var edits = 0;
      for (final state in EstadoOperacionCarga.values.map(
        (value) => value.value,
      )) {
        await tester.pumpWidget(
          host(
            CargaCard(
              item: OperacionCarga(
                id: 1,
                idSedeOrigen: 1,
                idCamion: 1,
                fechaCarga: DateTime(2026),
                estado: state,
              ),
              onOpen: () => opens++,
              onEdit: () => edits++,
              onAssignCarga: () => assignments++,
            ),
          ),
        );
        expect(find.text('Editar'), findsNothing);
        await tester.tap(find.text('Ver detalles'));
        final button = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Asignar carga'),
        );
        final canAssign = [
          'pendiente',
          'en_curso',
          'en_transito',
        ].contains(state);
        expect(button.onPressed != null, canAssign);
        if (canAssign) await tester.tap(find.text('Asignar carga'));
        await tester.tap(find.byTooltip('Más acciones'));
        await tester.pumpAndSettle();
        final menuItem = tester.widget<PopupMenuItem>(
          find.byType(PopupMenuItem<AppCardMenuAction>),
        );
        final canEdit = ['pendiente', 'en_curso'].contains(state);
        expect(menuItem.enabled, canEdit);
        if (canEdit) {
          await tester.tap(find.text('Editar'));
        } else {
          await tester.tapAt(const Offset(700, 500));
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      expect(opens, EstadoOperacionCarga.values.length);
      expect(assignments, 3);
      expect(edits, 2);
    },
  );
}
