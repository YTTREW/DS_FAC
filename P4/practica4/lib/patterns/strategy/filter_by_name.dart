import 'recipe_filter_strategy.dart';
import '../../models/recipe.dart';

class FilterByName implements RecipeFilterStrategy {
  @override
  List<Recipe> apply(List<Recipe> recipes) {
    List<Recipe> sortedList = List.from(recipes);

    sortedList.sort((a, b) => a.name.compareTo(b.name));

    return sortedList;
  }
}
