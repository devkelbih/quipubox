import 'package:quipubox/core/state/base_state_viewmodel.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/cliente_page.dart';
import '../../domain/usecases/create_cliente.dart';
import '../../domain/usecases/change_cliente_estado.dart';
import '../../domain/usecases/get_clientes_page.dart';
import '../../domain/usecases/update_cliente.dart';

class ClienteViewModel extends BaseStateViewModel {
  final GetClientesPageUseCase getPageUseCase;
  final CreateClienteUseCase createUseCase;
  final UpdateClienteUseCase updateUseCase;
  final ChangeClienteEstadoUseCase changeStatusUseCase;

  ClienteViewModel({
    required this.getPageUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.changeStatusUseCase,
  });

  List<Cliente> items = [];
  int currentPage = 1;
  int totalPages = 0;
  int total = 0;
  int activeCount = 0;
  int inactiveCount = 0;
  int get totalCount => activeCount + inactiveCount;
  static const pageSize = 10;
  String buscar = '';
  bool? estado;
  String? tipoRelacion;
  bool _queued = false;
  int _targetPage = 1;

  Future<void> setFilters({
    required String buscar,
    required bool? estado,
    String? tipoRelacion,
  }) {
    this.buscar = buscar.trim();
    this.estado = estado;
    this.tipoRelacion = tipoRelacion;
    items = [];
    return load(page: 1);
  }

  Future<void> load({int? page}) async {
    _targetPage = page ?? currentPage;
    _queued = true;
    // Serializar cambios rápidos de búsqueda/filtro: conservar la última consulta
    // sin descartar la petición nueva ni mostrar resultados de filtros anteriores.
    if (isLoading) return;
    while (_queued) {
      _queued = false;
      final target = _targetPage;
      final search = buscar;
      final status = estado;
      final relation = tipoRelacion;
      final result = await run<List<ClientePage>>(
        state: ViewModelActionState.loading,
        notifyOnEnd: false,
        action: () => Future.wait([
          getPageUseCase(
            page: target,
            limit: pageSize,
            buscar: search,
            estado: status,
            tipoRelacion: relation,
          ),
          // La API no ofrece resumen por estado: consultar sus totales con limit=1.
          getPageUseCase(
            limit: 1,
            buscar: search,
            tipoRelacion: relation,
            estado: true,
          ),
          getPageUseCase(
            limit: 1,
            buscar: search,
            tipoRelacion: relation,
            estado: false,
          ),
        ]),
      );
      if (_queued) continue;
      if (result != null) {
        final data = result[0];
        final lastPage = data.totalPages < 1 ? 1 : data.totalPages;
        if (target > lastPage) {
          _targetPage = lastPage;
          _queued = true;
          continue;
        }
        items = data.items;
        currentPage = data.page;
        totalPages = data.totalPages;
        total = data.total;
        activeCount = result[1].total;
        inactiveCount = result[2].total;
      }
    }
    notifyListeners();
  }

  Future<bool> create(Cliente cliente) => runBool(
    state: ViewModelActionState.saving,
    action: () async {
      await createUseCase(cliente);
      await load(page: 1);
    },
  );

  Future<bool> update(Cliente cliente) => runBool(
    state: ViewModelActionState.saving,
    action: () async {
      await updateUseCase(cliente);
      await load();
    },
  );

  Future<bool> changeStatus({required int id, required bool estado}) => runBool(
    state: ViewModelActionState.changingStatus,
    action: () async {
      await changeStatusUseCase(id: id, estado: estado);
      await load();
    },
  );
}
