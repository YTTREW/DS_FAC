import 'package:flutter/foundation.dart';

class IngredientProvider extends ChangeNotifier {
  // Lista de ingredientes disponibles que el usuario tiene
  Set<String> _availableIngredients = <String>{};

  // Lista de todos los ingredientes conocidos en el sistema
  Set<String> _allKnownIngredients = <String>{};

  // Estado de carga
  bool _isLoading = false;

  // Error handling
  String? _error;

  // Getters
  Set<String> get availableIngredients =>
      Set.unmodifiable(_availableIngredients);
  Set<String> get allKnownIngredients => Set.unmodifiable(_allKnownIngredients);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getter para ingredientes sugeridos (conocidos pero no disponibles)
  Set<String> get suggestedIngredients {
    return _allKnownIngredients.difference(_availableIngredients);
  }

  // Getter para estadísticas
  int get availableCount => _availableIngredients.length;
  int get totalKnownCount => _allKnownIngredients.length;

  /// Inicializa el provider con ingredientes por defecto
  void initialize() {
    _initializeDefaultIngredients();
    _loadSavedIngredients();
  }

  /// Añade un ingrediente a la lista de disponibles
  void addIngredient(String ingredient) {
    if (ingredient.trim().isEmpty) return;

    final cleanIngredient = _cleanIngredientName(ingredient);

    if (_availableIngredients.add(cleanIngredient)) {
      _allKnownIngredients.add(cleanIngredient);
      _saveIngredientsToStorage();
      _clearError();
      notifyListeners();
    }
  }

  /// Elimina un ingrediente de la lista de disponibles
  void removeIngredient(String ingredient) {
    if (_availableIngredients.remove(ingredient)) {
      _saveIngredientsToStorage();
      notifyListeners();
    }
  }

  /// Añade múltiples ingredientes de una vez
  void addMultipleIngredients(List<String> ingredients) {
    bool hasChanges = false;

    for (String ingredient in ingredients) {
      if (ingredient.trim().isNotEmpty) {
        final cleanIngredient = _cleanIngredientName(ingredient);
        if (_availableIngredients.add(cleanIngredient)) {
          _allKnownIngredients.add(cleanIngredient);
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      _saveIngredientsToStorage();
      _clearError();
      notifyListeners();
    }
  }

  /// Elimina múltiples ingredientes de una vez
  void removeMultipleIngredients(List<String> ingredients) {
    bool hasChanges = false;

    for (String ingredient in ingredients) {
      if (_availableIngredients.remove(ingredient)) {
        hasChanges = true;
      }
    }

    if (hasChanges) {
      _saveIngredientsToStorage();
      notifyListeners();
    }
  }

  /// Limpia todos los ingredientes disponibles
  void clearAllIngredients() {
    if (_availableIngredients.isNotEmpty) {
      _availableIngredients.clear();
      _saveIngredientsToStorage();
      notifyListeners();
    }
  }

  /// Verifica si un ingrediente específico está disponible
  bool hasIngredient(String ingredient) {
    return _availableIngredients.contains(ingredient);
  }

  /// Verifica si todos los ingredientes de una lista están disponibles
  bool hasAllIngredients(List<String> requiredIngredients) {
    return requiredIngredients.every(
      (ingredient) => _availableIngredients.contains(ingredient),
    );
  }

  /// Obtiene los ingredientes faltantes de una lista requerida
  List<String> getMissingIngredients(List<String> requiredIngredients) {
    return requiredIngredients
        .where((ingredient) => !_availableIngredients.contains(ingredient))
        .toList();
  }

  /// Obtiene sugerencias de ingredientes basadas en texto parcial
  List<String> getIngredientSuggestions(String partialText) {
    if (partialText.trim().isEmpty) return [];

    final query = partialText.toLowerCase().trim();

    return _allKnownIngredients
        .where(
          (ingredient) =>
              ingredient.toLowerCase().contains(query) &&
              !_availableIngredients.contains(ingredient),
        )
        .take(5) // Limitar a 5 sugerencias
        .toList()
      ..sort(); // Ordenar alfabéticamente
  }

  /// Añade ingredientes desde una receta al conocimiento del sistema
  void learnIngredientsFromRecipe(List<String> recipeIngredients) {
    bool hasNewIngredients = false;

    for (String ingredient in recipeIngredients) {
      final cleanIngredient = _cleanIngredientName(ingredient);
      if (_allKnownIngredients.add(cleanIngredient)) {
        hasNewIngredients = true;
      }
    }

    if (hasNewIngredients) {
      // No notificar cambios aquí ya que solo estamos aprendiendo ingredientes
      // Los ingredientes aprendidos aparecerán en sugerencias
    }
  }

  /// Alternar el estado de un ingrediente (disponible/no disponible)
  void toggleIngredient(String ingredient) {
    if (_availableIngredients.contains(ingredient)) {
      removeIngredient(ingredient);
    } else {
      addIngredient(ingredient);
    }
  }

  /// Establecer estado de carga
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Establecer error
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Limpiar error
  void _clearError() {
    if (_error != null) {
      _error = null;
      // No notificar aquí para evitar builds innecesarios
    }
  }

  /// Limpiar nombre del ingrediente (trim, lowercase, etc.)
  String _cleanIngredientName(String ingredient) {
    return ingredient.trim().toLowerCase();
  }

  /// Inicializar con ingredientes comunes por defecto
  void _initializeDefaultIngredients() {
    _allKnownIngredients.addAll([
      // Proteínas
      'pollo', 'carne', 'pescado', 'huevos', 'tofu', 'lentejas', 'garbanzos',

      // Vegetales
      'cebolla', 'ajo', 'tomate', 'pimiento', 'zanahoria', 'apio', 'brócoli',
      'espinacas', 'lechuga', 'pepino', 'calabacín', 'berenjena',

      // Condimentos y especias
      'sal', 'pimienta', 'aceite de oliva', 'vinagre', 'limón', 'perejil',
      'albahaca', 'orégano', 'tomillo', 'romero', 'comino', 'paprika',

      // Lácteos
      'leche', 'queso', 'mantequilla', 'yogur', 'nata',

      // Cereales y legumbres
      'arroz', 'pasta', 'pan', 'harina', 'avena', 'quinoa',

      // Otros básicos
      'azúcar', 'miel', 'chocolate', 'vainilla', 'canela',
    ]);
  }

  /// Cargar ingredientes guardados del almacenamiento local
  void _loadSavedIngredients() {
    // TODO: Implementar carga desde SharedPreferences
    // Por ahora, usar algunos ingredientes por defecto para demo
    _availableIngredients.addAll([
      'pollo',
      'arroz',
      'cebolla',
      'ajo',
      'aceite de oliva',
      'sal',
      'pimienta',
    ]);
  }

  /// Guardar ingredientes en almacenamiento local
  void _saveIngredientsToStorage() {
    // TODO: Implementar guardado en SharedPreferences
    // Por ahora, solo simular el guardado
    debugPrint('Guardando ingredientes: $_availableIngredients');
  }

  /// Exportar ingredientes disponibles como lista
  List<String> exportAvailableIngredients() {
    return _availableIngredients.toList()..sort();
  }

  /// Importar ingredientes desde una lista
  void importIngredients(List<String> ingredients) {
    _setLoading(true);

    try {
      _availableIngredients.clear();
      for (String ingredient in ingredients) {
        final cleanIngredient = _cleanIngredientName(ingredient);
        _availableIngredients.add(cleanIngredient);
        _allKnownIngredients.add(cleanIngredient);
      }

      _saveIngredientsToStorage();
      _clearError();
    } catch (e) {
      _setError('Error al importar ingredientes: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Resetear a ingredientes por defecto
  void resetToDefaults() {
    _availableIngredients.clear();
    _availableIngredients.addAll([
      'pollo',
      'arroz',
      'cebolla',
      'ajo',
      'aceite de oliva',
      'sal',
      'pimienta',
    ]);
    _saveIngredientsToStorage();
    notifyListeners();
  }

  /// Obtener estadísticas de uso
  Map<String, dynamic> getStatistics() {
    return {
      'availableCount': _availableIngredients.length,
      'totalKnownCount': _allKnownIngredients.length,
      'completionPercentage':
          _allKnownIngredients.isEmpty
              ? 0.0
              : (_availableIngredients.length / _allKnownIngredients.length) *
                  100,
      'suggestedCount': suggestedIngredients.length,
    };
  }

  @override
  void dispose() {
    // Guardar estado final antes de dispose
    _saveIngredientsToStorage();
    super.dispose();
  }
}
