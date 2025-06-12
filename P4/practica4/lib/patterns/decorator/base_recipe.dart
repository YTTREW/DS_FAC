import 'recipe_component.dart';
import '../../models/recipe.dart';

class BaseRecipe implements RecipeComponent {
  final Recipe recipe;

  BaseRecipe(this.recipe);

  @override
  String getDescription() {
    return "Receta: ${recipe.name}";
  }
}
