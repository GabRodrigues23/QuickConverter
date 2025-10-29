import 'package:QuickConverter/core/theme/app_themes.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  AppThemeType _currentTheme = AppThemeType.blue;
  AppThemeType get currentTheme => _currentTheme;
  ThemeData get currentThemeData => AppThemes.getTheme(_currentTheme);

  void setTheme(AppThemeType themeType) {
    if (_currentTheme != themeType) {
      _currentTheme = themeType;
      notifyListeners();
    }
  }
}
