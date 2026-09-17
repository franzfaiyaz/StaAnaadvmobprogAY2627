import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme(bool enabled) {
    _isDark = enabled;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  );

  ThemeData get darkTheme =>
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue);
}
