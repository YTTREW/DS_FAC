import 'estrategia_receta.dart';
import 'recipe.dart';
class FilterByName implements RecipeFilterStrategy {
  @override
  List<Recipe> apply(List<Recipe> recipes) {
    List<Recipe> sortedList = List.from(recipes);

    for (int i = 0; i < sortedList.length - 1; i++) {
      for (int j = i + 1; j < sortedList.length; j++) {
        if (sortedList[i].name.compareTo(sortedList[j].name) > 0) {
          final temp = sortedList[i];
          sortedList[i] = sortedList[j];
          sortedList[j] = temp;
        }
      }
    }

    return sortedList;
  }
}