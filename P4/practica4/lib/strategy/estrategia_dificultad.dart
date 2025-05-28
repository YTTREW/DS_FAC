import 'recipe.dart';
import 'estrategia_receta.dart';
class FilterByDifficulty implements RecipeFilterStrategy {
  @override
  List<Recipe> apply(List<Recipe> recipes) {
    List<Recipe> sortedList = List.from(
        recipes); // copia para no modificar la original

    for (int i = 0; i < sortedList.length - 1; i++) {
      for (int j = i + 1; j < sortedList.length; j++) {
        if (sortedList[i].difficulty > sortedList[j].difficulty) {
          final temp = sortedList[i];
          sortedList[i] = sortedList[j];
          sortedList[j] = temp;
        }
      }
    }

    return sortedList;
  }
}