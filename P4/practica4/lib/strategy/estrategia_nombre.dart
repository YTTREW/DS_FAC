import 'estrategia_receta.dart';
import 'recipe.dart';
class FilterByName implements RecipeFilterStrategy {
  @override
  List<Recipe> apply(List<Recipe> recipes) {
    recipes.sort((a, b) => a.name.compareTo(b.name));
    return recipes;
  }
}
