import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  static const String _themePreferenceKey = 'isDarkMode';

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Carga el tema guardado en las preferencias
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    notifyListeners();
  }

  // Guarda la preferencia del tema y notifica a los oyentes
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode);

    notifyListeners();
  }

  // Obtiene el tema actual basado en el modo oscuro
  ThemeData getTheme() {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
          primaryColor: Colors.deepOrangeAccent,
          colorScheme: ColorScheme.dark(
            primary: Colors.orangeAccent,
            secondary: Colors.tealAccent,
          ),
          appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[900]),
          cardTheme: CardTheme(color: Colors.blueGrey[700], elevation: 4),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
          ),
        )
        : ThemeData.light().copyWith(
          primaryColor: Colors.black,
          colorScheme: ColorScheme.light(
            primary: Colors.orange,
            secondary: Colors.lightBlueAccent,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.cyan),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.cyan,
            foregroundColor: Colors.white,
          ),
        );
  }
}
