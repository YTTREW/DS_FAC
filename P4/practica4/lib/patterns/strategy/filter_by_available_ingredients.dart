import 'recipe_filter_strategy.dart';
import '../../models/recipe.dart';

class FilterByAvailableIngredients implements RecipeFilterStrategy {
  final List<String> availableIngredients;

  FilterByAvailableIngredients(this.availableIngredients);

  @override
  List<Recipe> apply(List<Recipe> recipes) {
    return recipes.where((recipe) {
      return recipe.ingredients.every(
        (ingredient) => availableIngredients.contains(ingredient),
      );
    }).toList();
  }
}
