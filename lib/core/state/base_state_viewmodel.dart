import '../mappers/error_message_mapper.dart';
import 'safe_change_notifier.dart';

enum ViewModelActionState { loading, saving, changingStatus, deleting }

class BaseStateViewModel extends SafeChangeNotifier {
  bool isLoading = false;
  bool isSaving = false;
  bool isChangingStatus = false;
  bool isDeleting = false;

  String? errorMessage;

  bool get isBusy => isLoading || isSaving || isChangingStatus || isDeleting;

  bool isRunning(ViewModelActionState state) {
    return switch (state) {
      ViewModelActionState.loading => isLoading,
      ViewModelActionState.saving => isSaving,
      ViewModelActionState.changingStatus => isChangingStatus,
      ViewModelActionState.deleting => isDeleting,
    };
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<T?> run<T>({
    required Future<T> Function() action,
    required ViewModelActionState state,
    bool preventDuplicates = true,
    bool notifyOnStart = true,
    bool notifyOnEnd = true,
  }) async {
    if (preventDuplicates && isRunning(state)) {
      return null;
    }

    _setState(state, true);
    errorMessage = null;

    if (notifyOnStart) notifyListeners();

    try {
      return await action();
    } on Object catch (e) {
      errorMessage = ErrorMessageMapper.map(e);
      return null;
    } finally {
      _setState(state, false);
      if (notifyOnEnd) notifyListeners();
    }
  }

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
