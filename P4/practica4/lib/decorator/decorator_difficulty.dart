import 'component.dart';
import 'abstract_decorator.dart';
import '../strategy/recipe.dart';

class DifficultyDecorator extends RecipeDecorator {
  final int difficulty;

  DifficultyDecorator(super.component, this.difficulty);

  @override
  String getDescription() {
    final stars = '⭐' * difficulty;
    return "${super.getDescription()}\nDificultad: $difficulty $stars";
  }
}