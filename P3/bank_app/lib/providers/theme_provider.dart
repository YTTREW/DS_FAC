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
          primaryColor: Colors.blueGrey[800],
          colorScheme: ColorScheme.dark(
            primary: Colors.blueGrey[800]!,
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
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.light(
            primary: Colors.blue,
            secondary: Colors.lightBlueAccent,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        );
  }
}
