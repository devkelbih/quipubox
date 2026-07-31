import 'dart:async';
import 'package:flutter/widgets.dart';

import '../state/safe_change_notifier.dart';
import 'network_checker.dart';

/// ===============================================================
/// ConnectivityViewModel
/// ---------------------------------------------------------------
/// Se encarga de controlar el estado de la conexión a internet
/// durante toda la ejecución de la aplicación.
///
/// Responsabilidades:
/// - Consultar si hay conexión a internet.
/// - Mantener el estado actual de la conexión.
/// - Notificar a la interfaz cuando el estado cambia.
/// - Iniciar y detener las verificaciones periódicas.
/// - Pausar las verificaciones cuando la aplicación pasa
///   a segundo plano.
/// - Reanudar las verificaciones al volver al primer plano.
/// ===============================================================
class ConnectivityViewModel extends SafeChangeNotifier
    with WidgetsBindingObserver {
  /// Servicio encargado de comprobar si existe conexión a internet.
  final NetworkChecker networkChecker;

  ConnectivityViewModel({required this.networkChecker}) {
    // Escucha los cambios del ciclo de vida de la aplicación
    // (resumed, paused, detached, etc.).
    WidgetsBinding.instance.addObserver(this);
  }

  /// Timer que realiza comprobaciones periódicas de la conexión.
  Timer? _timer;

  /// Timer usado para esperar un breve momento cuando la aplicación
  /// vuelve al primer plano antes de realizar una nueva comprobación.
  Timer? _debounceTimer;

  /// Estado actual de la conexión.
  ///
  /// true  -> Hay conexión.
  /// false -> No hay conexión.
  bool isOnline = true;

  /// Indica si ya se realizó al menos una comprobación desde que
  /// inició la aplicación.
  ///
  /// Esto evita que la interfaz muestre información antes de conocer
  /// el estado real de la conexión.
  bool hasCheckedOnce = false;

  /// Inicia el monitoreo de la conexión.
  ///
  /// Primero realiza una comprobación inmediata y luego inicia
  /// las comprobaciones periódicas.
  Future<void> start() async {
    await checkNow();
    _startPeriodicTimer();
  }

  /// Inicia el timer que verifica la conexión cada 10 segundos.
  ///
  /// Si ya existe un timer activo, primero se cancela para evitar
  /// que existan varios ejecutándose al mismo tiempo.
  void _startPeriodicTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => checkNow(),
    );
  }

  /// Detiene todas las comprobaciones activas.
  ///
  /// Se utiliza cuando la aplicación pasa a segundo plano
  /// o cuando el ViewModel es destruido.
  void _stopPeriodicTimer() {
    _timer?.cancel();
    _timer = null;

    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Comprueba el estado actual de la conexión.
  ///
  /// Solo notifica a la interfaz cuando:
  /// - Es la primera comprobación.
  /// - El estado de la conexión cambió.
  ///
  /// Esto evita reconstrucciones innecesarias de la interfaz.
  Future<void> checkNow() async {
    final result = await networkChecker.hasInternet();

    if (result != isOnline || !hasCheckedOnce) {
      isOnline = result;
      hasCheckedOnce = true;

      notifyListeners();
    }
  }

  /// Se ejecuta automáticamente cuando cambia el estado de la aplicación.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // La aplicación pasó a segundo plano.
      // Se detienen las comprobaciones para ahorrar recursos.
      _stopPeriodicTimer();
    } else if (state == AppLifecycleState.resumed) {
      // La aplicación volvió al primer plano.
      //
      // Se espera un breve momento para que la conexión del dispositivo
      // termine de estabilizarse antes de realizar una nueva comprobación.
      _debounceTimer?.cancel();

      _debounceTimer = Timer(
        const Duration(milliseconds: 400),
        () async {
          await checkNow();
          _startPeriodicTimer();
        },
      );
    }
  }

  @override
  void dispose() {
    // Deja de escuchar los cambios del ciclo de vida.
    WidgetsBinding.instance.removeObserver(this);

    // Cancela todos los timers activos.
    _stopPeriodicTimer();

    super.dispose();
  }
}