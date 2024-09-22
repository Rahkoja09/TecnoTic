import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  bool _isLargeTextMode = false;
  bool _isScreenReaderEnabled = false;

  bool get isLargeTextMode => _isLargeTextMode;
  bool get isScreenReaderEnabled => _isScreenReaderEnabled;

  ThemeData get currentTheme => _currentTheme;
  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void setLargeTextMode(bool value) {
    _isLargeTextMode = value;
    notifyListeners();
  }

  void setScreenReaderEnabled(bool value) {
    _isScreenReaderEnabled = value;
    notifyListeners();
  }

  void resetModes() {
    _isLargeTextMode = false;
    _isScreenReaderEnabled = false;
    notifyListeners();
  }

  void setCustomColors({
    required Color backgroundColor,
    required Color cardColor,
    required Color textColor,
    required Color iconColor,
  }) {
    _currentTheme = ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: textColor),
        bodyText2: TextStyle(color: textColor),
      ),
      iconTheme: IconThemeData(color: iconColor),
    );
    notifyListeners();
  }
}
