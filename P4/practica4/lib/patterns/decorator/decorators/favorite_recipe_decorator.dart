import '../abstract_decorator.dart';

class FavoriteRecipeDecorator extends RecipeDecorator {
  FavoriteRecipeDecorator(super.component);

  @override
  String getDescription() {
    return "${super.getDescription()} ❤️ (Favorita)";
  }
}
