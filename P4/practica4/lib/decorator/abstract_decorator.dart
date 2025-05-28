import 'component.dart';
abstract class RecipeDecorator implements RecipeComponent {
  final RecipeComponent recipeComponent;

  RecipeDecorator(this.recipeComponent);

  @override
  String getDescription() => recipeComponent.getDescription();
}
