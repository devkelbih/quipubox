import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  Timer? _timer;
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityService() {
    checkNow();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) => checkNow());
  }

  Future<void> checkNow() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      _setOnline(result.isNotEmpty && result.first.rawAddress.isNotEmpty);
    } catch (_) {
      _setOnline(false);
    }
  }

  void _setOnline(bool value) {
    if (_isOnline == value) return;
    _isOnline = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
