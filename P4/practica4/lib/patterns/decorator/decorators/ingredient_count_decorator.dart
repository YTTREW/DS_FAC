import '../recipe_decorator.dart';
import '../../../models/recipe.dart';

class IngredientCountDecorator extends RecipeDecorator {
  final Recipe recipe;

  IngredientCountDecorator(super.component, this.recipe);

  @override
  String getDescription() {
    final count = recipe.ingredients.length;
    final list = recipe.ingredients.join(', ');
    return "${super.getDescription()}\n🧂 Ingredientes ($count): $list";
  }
}
