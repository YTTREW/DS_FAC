import 'recipe.dart';
import 'estrategia_receta.dart';
class FilterByDifficulty implements RecipeFilterStrategy {
  @override
  List<Recipe> apply(List<Recipe> recipes) {
    recipes.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    return recipes;
  }
}
