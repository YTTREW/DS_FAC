import '../recipe_decorator.dart';

class FavoriteRecipeDecorator extends RecipeDecorator {
  FavoriteRecipeDecorator(super.component);

  @override
  String getDescription() {
    return "${super.getDescription()}\n❤️ (Favorita)";
  }
}
