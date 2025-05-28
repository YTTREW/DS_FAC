import 'component.dart';
import '../strategy/recipe.dart';
class BasicRecipe implements RecipeComponent {
  final Recipe recipe;

  BasicRecipe(this.recipe);

  @override
  String getDescription() {
    return "Receta: ${recipe.name}";
  }
}
