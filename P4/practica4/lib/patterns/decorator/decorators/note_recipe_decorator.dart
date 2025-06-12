import '../recipe_decorator.dart';

class NoteRecipeDecorator extends RecipeDecorator {
  final String note;

  NoteRecipeDecorator(super.component, this.note);

  @override
  String getDescription() {
    return "${super.getDescription()} 📝 Nota: $note";
  }
}
