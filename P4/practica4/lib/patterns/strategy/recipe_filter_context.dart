import 'recipe_filter_strategy.dart';
import '../../models/recipe.dart';

/// Context del patrón Strategy
/// Mantiene una referencia a una estrategia y delega el trabajo a ella
class RecipeFilterContext {
  RecipeFilterStrategy? _strategy;

  /// Constructor que opcionalmente recibe una estrategia inicial
  RecipeFilterContext([this._strategy]);

  /// Setter para cambiar la estrategia en tiempo de ejecución
  void setStrategy(RecipeFilterStrategy? strategy) {
    _strategy = strategy;
  }

  /// Getter para obtener la estrategia actual
  RecipeFilterStrategy? get currentStrategy => _strategy;

  /// Método principal que ejecuta la estrategia actual
  /// Delega la operación a la estrategia concreta
  List<Recipe> executeStrategy(List<Recipe> recipes) {
    if (_strategy == null) {
      return List.from(recipes); // Sin filtro, devuelve copia original
    }
    return _strategy!.apply(recipes);
  }

  /// Verifica si hay una estrategia activa
  bool hasActiveStrategy() => _strategy != null;

  /// Limpia la estrategia actual (sin filtro)
  void clearStrategy() {
    _strategy = null;
  }

  /// Obtiene información sobre la estrategia actual
  String getStrategyDescription() {
    if (_strategy == null) return 'Sin filtro aplicado';

    switch (_strategy.runtimeType.toString()) {
      case 'FilterByName':
        return 'Filtrado por nombre';
      case 'FilterByDifficulty':
        return 'Filtrado por dificultad';
      case 'FilterByAvailableIngredients':
        return 'Filtrado por ingredientes disponibles';
      default:
        return 'Filtro personalizado';
    }
  }

  /// Obtiene el tipo de estrategia actual
  String? getStrategyType() {
    return _strategy?.runtimeType.toString();
  }
}
