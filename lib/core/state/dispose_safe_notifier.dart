import 'package:flutter/foundation.dart';

class DisposeSafeNotifier extends ChangeNotifier {
  bool _disposed = false;
  @override
  void notifyListeners() { if (!_disposed) super.notifyListeners(); }
  @override
  void dispose() { _disposed = true; super.dispose(); }
}
