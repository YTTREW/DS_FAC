import '../recipe_decorator.dart';

class DifficultyDecorator extends RecipeDecorator {
  final int difficulty;

  DifficultyDecorator(super.component, this.difficulty);

  @override
  String getDescription() {
    final indicator = _getDifficultyIndicator(difficulty);
    final label = _getDifficultyLabel(difficulty);
    return "${super.getDescription()}\nDificultad: $indicator $label ($difficulty/10)";
  }

  String _getDifficultyIndicator(int level) {
    if (level <= 2) return '🟢'; // Verde - Muy fácil
    if (level <= 4) return '🔵'; // Azul - Fácil
    if (level <= 6) return '🟡'; // Amarillo - Intermedio
    if (level <= 8) return '🟠'; // Naranja - Difícil
    return '🔴'; // Rojo - Muy difícil
  }

  String _getDifficultyLabel(int level) {
    if (level <= 2) return 'Muy Fácil';
    if (level <= 4) return 'Fácil';
    if (level <= 6) return 'Intermedio';
    if (level <= 8) return 'Difícil';
    return 'Muy Difícil';
  }
}
