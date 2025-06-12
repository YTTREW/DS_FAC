import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
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
      final data = await ApiService.obtenerRecetas();
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
      await ApiService.crearReceta(recipe.toJson());
      await loadRecipes();
      return true;
    } catch (e) {
      _setError('Error al crear receta: $e');
      return false;
    }
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    if (recipe.id == null) return false;

    try {
      _clearError();
      await ApiService.actualizarReceta(recipe.id!, recipe.toJson());
      await loadRecipes();
      return true;
    } catch (e) {
      _setError('Error al actualizar receta: $e');
      return false;
    }
  }

  Future<bool> deleteRecipe(Recipe recipe) async {
    if (recipe.id == null) return false;

    try {
      _clearError();
      await ApiService.eliminarReceta(recipe.id!);
      await loadRecipes();
      return true;
    } catch (e) {
      _setError('Error al eliminar receta: $e');
      return false;
    }
  }

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
