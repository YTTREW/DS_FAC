import 'package:flutter/foundation.dart';

class IngredientProvider extends ChangeNotifier {
  final Set<String> _availableIngredients = {};

  // Lista de ingredientes comunes para seleccionar
  static const List<String> commonIngredients = [
    'arroz',
    'pasta',
    'pollo',
    'ternera',
    'cerdo',
    'pescado',
    'huevos',
    'leche',
    'queso',
    'mantequilla',
    'aceite de oliva',
    'tomate',
    'cebolla',
    'ajo',
    'patata',
    'zanahoria',
    'pimiento',
    'lechuga',
    'pepino',
    'apio',
    'brócoli',
    'espinacas',
    'manzana',
    'plátano',
    'limón',
    'naranja',
    'pan',
    'harina',
    'azúcar',
    'sal',
    'pimienta',
    'albahaca',
    'perejil',
    'orégano',
    'tomillo',
  ];

  Set<String> get availableIngredients =>
      Set.unmodifiable(_availableIngredients);

  void addIngredient(String ingredient) {
    _availableIngredients.add(ingredient.trim().toLowerCase());
    notifyListeners();
  }

  void removeIngredient(String ingredient) {
    _availableIngredients.remove(ingredient.trim().toLowerCase());
    notifyListeners();
  }

  bool hasIngredient(String ingredient) {
    return _availableIngredients.contains(ingredient.trim().toLowerCase());
  }

  void clearAllIngredients() {
    _availableIngredients.clear();
    notifyListeners();
  }

  int get ingredientCount => _availableIngredients.length;
}
