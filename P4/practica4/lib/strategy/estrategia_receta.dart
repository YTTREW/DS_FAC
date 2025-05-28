import 'recipe.dart';
abstract class RecipeFilterStrategy {
  List<Recipe> apply(List<Recipe> recipes);
}
