import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga_calidad.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/contexto_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/repositories/reparto_repository.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/get_contexto_reparto.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_puesto.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_sede.dart';
import 'package:quipubox/features/organizacion/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';
import 'package:quipubox/features/organizacion/lugares_operativos/domain/entities/lugar_operativo.dart';
import 'package:quipubox/features/organizacion/lugares_operativos/domain/enums/lugar_operativo_tipos.dart';
import 'package:quipubox/features/organizacion/puestos/domain/entities/puesto.dart';

class Session implements CurrentSession {
  @override
  int get currentCompanyId => 1;
  @override
  int get currentUserId => 1;
  @override
  int get currentSedeId => 1;
}

final operation = OperacionCarga(
  id: 44,
  idSedeOrigen: 1,
  idSedeDestino: 2,
  idCamion: 1,
  fechaCarga: DateTime(2026),
  estado: 'en_transito',
);
const detail = DetalleCarga(
  id: 73,
  idOperacion: 44,
  idClienteEmisor: 1,
  idFruta: 1,
  idTipoJaba: 1,
  cantidadJabas: 100,
  esReparto: true,
  cantidadClasificada: 100,
);
const calidades = [
  DetalleCargaCalidad(
    id: 101,
    idDetalleCarga: 73,
    idCalidad: 1,
    cantidad: 60,
    nombreCalidad: 'Primera',
  ),
  DetalleCargaCalidad(
    id: 102,
    idDetalleCarga: 73,
    idCalidad: 2,
    cantidad: 40,
    nombreCalidad: 'Segunda',
  ),
];
const puesto = Puesto(
  id: 221,
  idLugar: 1,
  numeroPuesto: '221',
  lugarOperativo: LugarOperativo(
    id: 1,
    idSede: 2,
    nombre: 'Mercado',
    tipoLugar: LugarOperativoTipos.mercado,
  ),
);
const cliente = Cliente(
  id: 25,
  nombres: 'Carla',
  sedes: [
    ClienteSede(idSede: 2, tipoRelacion: TipoRelacionClienteSede.receptor),
  ],
  puestos: [ClientePuesto(idPuesto: 221, puesto: puesto)],
);
ContextoReparto contextData({
  List<Reparto> items = const [],
  bool directa = false,
  String estado = 'en_transito',
}) => ContextoReparto(
  operacion: operation.copyWith(estado: estado),
  detalle: detail.copyWith(esReparto: !directa),
  calidades: calidades,
  repartos: items,
  clientes: [cliente],
);

class Loader implements GetContextoRepartoUseCase {
  ContextoReparto data;
  int requests = 0;
  Loader(this.data);
  @override
  Future<ContextoReparto> call(int op, int detail) async {
    requests++;
    return data;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Repository implements RepartoRepository {
  final calls = <String>[];
  List<Reparto> items = [];
  List<AsignacionReparto>? saved;
  @override
  Future<List<Reparto>> getAll({
    int? detalleId,
    int? receptorId,
    int? puestoId,
    String? seccion,
  }) async => items;
  @override
  Future<Reparto> getById(int id) async => items.firstWhere((i) => i.id == id);
  @override
  Future<List<Reparto>> getByDetalle(int id) async =>
      items.where((i) => i.detalleId == id).toList();
  @override
  Future<void> createSimple(int id, AsignacionReparto item) async {
    calls.add('simple');
    saved = [item];
  }

  @override
  Future<void> createConCalidades(int id, AsignacionReparto item) async {
    calls.add('calidades');
    saved = [item];
  }

  @override
  Future<void> createMultiple(int id, List<AsignacionReparto> items) async {
    calls.add('multiple');
    saved = items;
  }

  @override
  Future<void> update(int id, int detail, AsignacionReparto item) async {
    calls.add('update');
    saved = [item];
  }

  @override
  Future<void> delete(int id) async {
    calls.add('delete');
  }

  @override
  Future<List<RepartoLinea>> getLineas(int id) async =>
      (await getById(id)).lineas;
  @override
  Future<RepartoLinea> getLinea(int id) async =>
      items.expand((i) => i.lineas).firstWhere((l) => l.id == id);
  @override
  Future<void> addLinea(int id, RepartoLinea item) async {
    calls.add('addLinea');
  }

  @override
  Future<void> updateLinea(int id, RepartoLinea item) async {
    calls.add('updateLinea');
  }

  @override
  Future<void> deleteLinea(int id) async {
    calls.add('deleteLinea');
  }
}

AsignacionReparto asignacion({
  int cantidad = 30,
  List<RepartoLinea> lineas = const [
    RepartoLinea(idCalidadCarga: 101, cantidad: 20),
    RepartoLinea(idCalidadCarga: 102, cantidad: 10),
  ],
  int receptor = 25,
}) => AsignacionReparto(
  receptorId: receptor,
  puestoId: 221,
  cantidad: cantidad,
  lineas: lineas,
);
