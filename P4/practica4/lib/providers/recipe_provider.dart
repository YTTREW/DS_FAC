import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../api/recetas_api.dart'; // ✅ Cambiar import
import '../patterns/strategy/recipe_filter_strategy.dart';
import '../patterns/strategy/recipe_filter_context.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  final Set<String> _favoriteRecipes = {};
  bool _isLoading = false;
  String? _error;

  final RecipeFilterContext _filterContext = RecipeFilterContext();

  // Getters
  List<Recipe> get recipes => _recipes;
  Set<String> get favoriteRecipes => _favoriteRecipes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Recipe> get filteredRecipes {
    return _filterContext.executeStrategy(_recipes);
  }

  bool get hasActiveFilter => _filterContext.hasActiveStrategy();
  String get filterDescription => _filterContext.getStrategyDescription();
  String? get currentFilterType => _filterContext.getStrategyType();

  // ✅ CRUD operations usando RecetaApi
  Future<void> loadRecipes() async {
    _setLoading(true);
    _clearError();
    try {
      final data = await RecetaApi.obtenerRecetas();
      _recipes = data.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      _setError('Error al cargar recetas: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addRecipe(Recipe recipe) async {
    try {
      _clearError();
      await RecetaApi.crearReceta(recipe.toJson());
      // Recargar todas las recetas para obtener el ID generado
      await loadRecipes();
      return true;
    } catch (e) {
      _setError('Error al crear receta: $e');
      return false;
    }
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    try {
      _clearError();
      if (recipe.id == null) {
        _setError('No se puede actualizar una receta sin ID');
        return false;
      }

      await RecetaApi.actualizarReceta(recipe.id!, {
        'nombre': recipe.name,
        'ingredientes': recipe.ingredients.join(', '),
        'instrucciones': recipe.instructions,
        'dificultad': recipe.difficulty,
        'tipo_comida': recipe.foodType,
      });

      // Actualizar en la lista local
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = recipe;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar receta: $e');
      return false;
    }
  }

  Future<bool> deleteRecipe(Recipe recipe) async {
    try {
      _clearError();
      if (recipe.id == null) {
        _setError('No se puede eliminar una receta sin ID');
        return false;
      }

      await RecetaApi.eliminarReceta(recipe.id!);
      _recipes.remove(recipe);
      _favoriteRecipes.remove(recipe.name);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar receta: $e');
      return false;
    }
  }

  // ✅ Resto de métodos sin cambios
  void toggleFavorite(String recipeName) {
    if (_favoriteRecipes.contains(recipeName)) {
      _favoriteRecipes.remove(recipeName);
    } else {
      _favoriteRecipes.add(recipeName);
    }
    notifyListeners();
  }

  bool isFavorite(String recipeName) {
    return _favoriteRecipes.contains(recipeName);
  }

  void setFilter(RecipeFilterStrategy? strategy) {
    _filterContext.setStrategy(strategy);
    notifyListeners();
  }

  void clearFilter() {
    _filterContext.clearStrategy();
    notifyListeners();
  }

  // Statistics
  int get totalRecipes => _recipes.length;
  int get filteredRecipesCount => filteredRecipes.length;
  int get favoriteRecipesCount => _favoriteRecipes.length;

  double get averageDifficulty {
    if (_recipes.isEmpty) return 0.0;
    final sum = _recipes.fold<int>(0, (sum, recipe) => sum + recipe.difficulty);
    return sum / _recipes.length;
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void resetProvider() {
    _recipes.clear();
    _favoriteRecipes.clear();
    _filterContext.clearStrategy();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _filterContext.clearStrategy();
    super.dispose();
  }
}
