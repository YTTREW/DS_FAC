import '../models/recipe.dart';
import '../api/recetas_api.dart';

class RecipeService {
  static Future<List<Recipe>> getAllRecipes() async {
    try {
      final data = await RecetaApi.obtenerRecetas();
      return data.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      throw RecipeException('Error al cargar recetas: $e');
    }
  }

  static Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      await RecetaApi.crearReceta(recipe.toJson());
      return recipe;
    } catch (e) {
      throw RecipeException('Error al crear receta: $e');
    }
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    try {
      await RecetaApi.actualizarReceta(recipe.id!, {
        'nombre': recipe.name,
        'ingredientes': recipe.ingredients.join(', '),
        'instrucciones': recipe.instructions,
        'dificultad': recipe.difficulty,
        'tipo_comida': recipe.foodType,
      });
    } catch (e) {
      throw RecipeException('Error al actualizar receta: $e');
    }
  }

  static Future<void> deleteRecipe(int id) async {
    try {
      await RecetaApi.eliminarReceta(id);
    } catch (e) {
      throw RecipeException('Error al eliminar receta: $e');
    }
  }
}

class RecipeException implements Exception {
  final String message;
  RecipeException(this.message);
}
