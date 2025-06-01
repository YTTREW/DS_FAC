import 'component.dart';
import 'abstract_decorator.dart';
import '../strategy/recipe.dart';

class InstructionsDecorator extends RecipeDecorator {
  final String instructions;

  InstructionsDecorator(super.component, this.instructions);

  @override
  String getDescription() {
    return "${super.getDescription()}\n📋 Instrucciones: $instructions";
  }
}

