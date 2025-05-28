import 'component.dart';
import 'abstract_decorator.dart';

class FoodTypeDecorator extends RecipeDecorator {
  final String tipo;

  FoodTypeDecorator(RecipeComponent component, this.tipo) : super(component);

  @override
  String getDescription() {
    final emoji = tipo == 'dulce' ? '🍰' : '🍕';
    return "$emoji ${super.getDescription()}";
  }
}
