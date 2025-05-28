import 'component.dart';
import 'abstract_decorator.dart';
import '../strategy/recipe.dart';

class IngredientCountDecorator extends RecipeDecorator {
  final Recipe recipe;

  IngredientCountDecorator(RecipeComponent component, this.recipe)
      : super(component);

  @override
  String getDescription() {
    return "${super.getDescription()} (${recipe.ingredients.length} ingredientes)";
  }
}
