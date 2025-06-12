import 'api_service.dart';
import '../models/recipe.dart';

class RecipeService {
  static Future<List<Recipe>> getAllRecipes() async {
    try {
      final data = await ApiService.obtenerRecetas();
      return data.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      throw RecipeException('Error al cargar recetas: $e');
    }
  }

  static Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      await ApiService.crearReceta(recipe.toJson());
      return recipe;
    } catch (e) {
      throw RecipeException('Error al crear receta: $e');
    }
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    try {
      await ApiService.actualizarReceta(recipe.id!, {
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
      await ApiService.eliminarReceta(id);
    } catch (e) {
      throw RecipeException('Error al eliminar receta: $e');
    }
  }
}

class RecipeException implements Exception {
  final String message;
  RecipeException(this.message);
}
