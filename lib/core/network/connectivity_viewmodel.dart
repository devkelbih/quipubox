import 'dart:async';

import '../state/safe_change_notifier.dart';
import 'network_checker.dart';

class ConnectivityViewModel extends SafeChangeNotifier {
  final NetworkChecker networkChecker;

  ConnectivityViewModel({required this.networkChecker});

  Timer? _timer;

  bool isOnline = true;
  bool hasCheckedOnce = false;

  Future<void> start() async {
    await checkNow();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) => checkNow());
  }

  Future<void> checkNow() async {
    final result = await networkChecker.hasInternet();

    if (result != isOnline || !hasCheckedOnce) {
      isOnline = result;
      hasCheckedOnce = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
