import 'recipe.dart';
import 'estrategia_receta.dart';
class FilterByAvailableIngredients implements RecipeFilterStrategy {
  final List<String> availableIngredients;

  FilterByAvailableIngredients(this.availableIngredients);

  @override
  List<Recipe> apply(List<Recipe> recipes) {
    List<Recipe> result = [];
    for (var recipe in recipes) {
      bool allIngredientsAvailable = true;
      for (var ing in recipe.ingredients) {
        if (!availableIngredients.contains(ing)) {
          allIngredientsAvailable = false;
          break;
        }
      }
      if (allIngredientsAvailable) {
        result.add(recipe);
      }
    }
    return result;

  }
}
