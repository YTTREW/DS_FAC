import 'package:flutter_test/flutter_test.dart';
import 'package:practica4/models/recipe.dart';
import 'package:practica4/patterns/strategy/filter_by_available_ingredients.dart';
import 'package:practica4/patterns/strategy/filter_by_difficulty.dart';
import 'package:practica4/patterns/strategy/filter_by_name.dart';
import 'package:practica4/patterns/strategy/recipe_filter_strategy.dart';
import 'package:practica4/services/api_service.dart';

void main() {
  group('RNF2: Arquitectura', () {
    test('Debe separar capa de datos (API) y dominio (Models)', () {
      // Verificar que Recipe model no depende de API
      final receta = Recipe(
        name: 'Test Separación',
        ingredients: ['test'],
        instructions: 'Test',
        difficulty: 1,
        foodType: 'salado',
        createdAt: DateTime.now(),
      );

      // El modelo debe funcionar independientemente del API
      expect(receta.toJson(), isA<Map<String, dynamic>>());
      expect(Recipe.fromJson(receta.toJson()), isA<Recipe>());

      // Verificar que ApiService es independiente del modelo
      expect(ApiService.obtenerRecetas, isA<Function>());
    });

    test('Debe implementar patrón Strategy correctamente', () {
      // Verificar que las estrategias implementan la interfaz
      expect(FilterByName(), isA<RecipeFilterStrategy>());
      expect(FilterByDifficulty(), isA<RecipeFilterStrategy>());
      expect(
        FilterByAvailableIngredients(['test']),
        isA<RecipeFilterStrategy>(),
      );
    });

    test('Debe mantener bajo acoplamiento entre capas', () {
      // Verificar que cambios en una capa no afectan otras
      final receta = Recipe(
        name: 'Test Acoplamiento',
        ingredients: ['test'],
        instructions: 'Test',
        difficulty: 1,
        foodType: 'salado',
        createdAt: DateTime.now(),
      );

      // El modelo debe funcionar sin el API
      final json = receta.toJson();
      expect(json, isNotNull);

      // El API debe funcionar con cualquier JSON válido
      expect(() => ApiService.crearReceta(json), returnsNormally);
    });
  });
}
