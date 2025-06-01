import 'component.dart';
import 'abstract_decorator.dart';
import '../strategy/recipe.dart';

class FoodTypeDecorator extends RecipeDecorator {
  final String tipo;

  FoodTypeDecorator(RecipeComponent component, this.tipo) : super(component);

  @override
  String getDescription() {
    final emoji = tipo == 'dulce' ? '🍰' : '🍕';
    return "${super.getDescription()}\n🍽️ Tipo de comida: $tipo $emoji\n";

  }
}
