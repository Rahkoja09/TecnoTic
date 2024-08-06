import 'package:flutter/foundation.dart';

class ModeProvider with ChangeNotifier {
  bool _isLargeTextMode = false;

  bool get isLargeTextMode => _isLargeTextMode;

  void setLargeTextMode(bool value) {
    _isLargeTextMode = value;
    notifyListeners();
  }
}
