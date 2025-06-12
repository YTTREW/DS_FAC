import '../recipe_decorator.dart';

class FoodTypeDecorator extends RecipeDecorator {
  final String tipo;

  FoodTypeDecorator(super.component, this.tipo);

  @override
  String getDescription() {
    final emoji = tipo == 'dulce' ? '🍰' : '🍕';
    return "${super.getDescription()}\n🍽️ Tipo de comida: $tipo $emoji";
  }
}
