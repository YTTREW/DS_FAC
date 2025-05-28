import 'component.dart';
import 'abstract_decorator.dart';
class FavoriteRecipeDecorator extends RecipeDecorator {
  FavoriteRecipeDecorator(RecipeComponent component) : super(component);

  @override
  String getDescription() {
    return "${super.getDescription()} ❤️ (Favorita)";
  }
}

class NoteRecipeDecorator extends RecipeDecorator {
  final String note;

  NoteRecipeDecorator(RecipeComponent component, this.note) : super(component);

  @override
  String getDescription() {
    return "${super.getDescription()} 📝 Nota: $note";
  }
}
