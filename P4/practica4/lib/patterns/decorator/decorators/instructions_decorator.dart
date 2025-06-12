import '../recipe_decorator.dart';

class InstructionsDecorator extends RecipeDecorator {
  final String instructions;

  InstructionsDecorator(super.component, this.instructions);

  @override
  String getDescription() {
    return "${super.getDescription()}\n📋 Instrucciones: $instructions";
  }
}
