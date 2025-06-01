import 'component.dart';
import 'abstract_decorator.dart';
import '../strategy/recipe.dart';

class IngredientCountDecorator extends RecipeDecorator {
  final Recipe recipe;

  IngredientCountDecorator(RecipeComponent component, this.recipe)
      : super(component);

  @override
  String getDescription() {
    final count = recipe.ingredients.length;
    final list = recipe.ingredients.join(', ');
    return "${super.getDescription()}\n🧂 Ingredientes ($count): $list";
  }
}
