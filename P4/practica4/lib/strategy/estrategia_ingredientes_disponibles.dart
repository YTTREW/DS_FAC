import 'recipe.dart';
import 'estrategia_receta.dart';
class FilterByAvailableIngredients implements RecipeFilterStrategy {
  final List<String> availableIngredients;

  FilterByAvailableIngredients(this.availableIngredients);

  @override
  List<Recipe> apply(List<Recipe> recipes) {
    return recipes.where((recipe) =>
        recipe.ingredients.every((ing) => availableIngredients.contains(ing))
    ).toList();
  }
}
