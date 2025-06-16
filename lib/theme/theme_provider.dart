import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme {
  galaxyBlue,
  darkMatter,
  pastelSky,
}

class ThemeProvider extends ChangeNotifier {

  AppTheme _currentTheme = AppTheme.galaxyBlue;
  AppTheme get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
    _saveTheme();
  }

  void _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedTheme', _currentTheme.name);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('selectedTheme');
    if (savedTheme != null) {
      _currentTheme = AppTheme.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => AppTheme.galaxyBlue,
      );
      notifyListeners();
    }
  }
}
