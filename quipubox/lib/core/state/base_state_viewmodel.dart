import '../mappers/error_message_mapper.dart';
import 'safe_change_notifier.dart';

/// Estados estándar utilizados por los ViewModels.
///
/// Permiten controlar indicadores visuales y prevenir
/// ejecuciones duplicadas de una misma operación.
enum ViewModelActionState {
  /// Carga inicial o recarga de datos.
  loading,

  /// Creación o actualización de registros.
  saving,

  /// Cambio de estado lógico (activar / desactivar).
  changingStatus,

  /// Eliminación física de registros.
  deleting,
}

/// Clase base para todos los ViewModels de la aplicación.
///
/// Centraliza:
///
/// - Estados de carga.
/// - Manejo de errores.
/// - Prevención de doble clic.
/// - Ejecución segura de operaciones asíncronas.
/// - Conversión de excepciones a mensajes amigables.
///
/// Evita repetir la misma lógica en cada módulo
/// (Sedes, Camiones, Frutas, Usuarios, etc.).
class BaseStateViewModel extends SafeChangeNotifier {
  /// Indica que se está cargando información.
  bool isLoading = false;

  /// Indica que se está guardando información.
  bool isSaving = false;

  /// Indica que se está cambiando el estado de un registro.
  bool isChangingStatus = false;

  /// Indica que se está eliminando un registro.
  bool isDeleting = false;

  /// Último mensaje de error ocurrido.
  String? errorMessage;

  /// Indica si existe cualquier operación en ejecución.
  ///
  /// Útil para bloquear acciones globales de la pantalla.
  bool get isBusy =>
      isLoading ||
      isSaving ||
      isChangingStatus ||
      isDeleting;

  /// Verifica si un estado específico ya se encuentra ejecutándose.
  ///
  /// Se utiliza principalmente para prevenir dobles clics
  /// o múltiples solicitudes simultáneas.
  bool isRunning(ViewModelActionState state) {
    return switch (state) {
      ViewModelActionState.loading => isLoading,
      ViewModelActionState.saving => isSaving,
      ViewModelActionState.changingStatus => isChangingStatus,
      ViewModelActionState.deleting => isDeleting,
    };
  }

  /// Limpia el último error registrado
  /// y notifica a la interfaz.
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  /// Ejecuta una operación asíncrona controlando automáticamente:
  ///
  /// - Estado de ejecución.
  /// - Manejo de errores.
  /// - Conversión de excepciones.
  /// - Notificaciones a la interfaz.
  /// - Prevención de ejecuciones duplicadas.
  ///
  /// Retorna:
  ///
  /// - El resultado de la operación cuando es exitosa.
  /// - null cuando ocurre un error.
  Future<T?> run<T>({
    required Future<T> Function() action,
    required ViewModelActionState state,

    /// Evita ejecutar nuevamente una operación
    /// si ya existe otra igual en proceso.
    bool preventDuplicates = true,

    /// Notifica a la UI al iniciar.
    bool notifyOnStart = true,

    /// Notifica a la UI al finalizar.
    bool notifyOnEnd = true,
  }) async {
    // Evita dobles clics o solicitudes duplicadas.
    if (preventDuplicates && isRunning(state)) {
      return null;
    }

    _setState(state, true);
    errorMessage = null;

    if (notifyOnStart) notifyListeners();

    try {
      return await action();
    } on Object catch (e) {
      // Convierte cualquier excepción
      // a un mensaje amigable para mostrar al usuario.
      errorMessage = ErrorMessageMapper.map(e);
      return null;
    } finally {
      _setState(state, false);

      if (notifyOnEnd) notifyListeners();
    }
  }

  /// Variante simplificada para operaciones
  /// que únicamente necesitan indicar éxito o fracaso.
  ///
  /// Convierte una operación Future< void>
  /// en un Future< bool>.
  Future<bool> runBool({
    required Future<void> Function() action,
    required ViewModelActionState state,
    bool preventDuplicates = true,
  }) async {
    final result = await run<bool>(
      state: state,
      preventDuplicates: preventDuplicates,
      action: () async {
        await action();
        return true;
      },
    );

    return result == true;
  }

  /// Activa o desactiva el flag correspondiente
  /// según el tipo de operación ejecutada.
  void _setState(ViewModelActionState state, bool value) {
    switch (state) {
      case ViewModelActionState.loading:
        isLoading = value;

      case ViewModelActionState.saving:
        isSaving = value;

      case ViewModelActionState.changingStatus:
        isChangingStatus = value;

      case ViewModelActionState.deleting:
        isDeleting = value;
    }
  }
}