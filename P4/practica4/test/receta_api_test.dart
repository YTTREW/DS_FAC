import 'package:flutter_test/flutter_test.dart';
import 'package:practica4/models/recipe.dart';
import 'package:practica4/services/api_service.dart';

void main() {
  group('ApiService CRUD Tests', () {
    //Test para crear una nueva receta
    test('Crear receta', () async {
      final receta = Recipe(
        name: 'Tarta',
        ingredients: ['harina', 'huevo'],
        instructions: 'Mezclar y hornear',
        difficulty: 2,
        foodType: 'dulce',
        createdAt: DateTime.now(),
      );

      await ApiService.crearReceta(receta.toJson());
      final recetas = await ApiService.obtenerRecetas();
      final encontrada = recetas.any((r) => r['nombre'] == 'Tarta');
      expect(encontrada, true);
    });

    //Test para obtener receta de la BD
    test('Obtener recetas', () async {
      final recetas = await ApiService.obtenerRecetas();
      expect(recetas, isA<List<dynamic>>());
    });

    //Test para actualizar los parametros de la receta
    test('Actualizar receta', () async {
      // Crea receta primero
      final nueva = Recipe(
        name: 'Bocadillo',
        ingredients: ['pan'],
        instructions: 'Paso 1: añadir pan',
        difficulty: 1,
        foodType: 'salado',
        createdAt: DateTime.now(),
      );
      await ApiService.crearReceta(nueva.toJson());

      final recetas = await ApiService.obtenerRecetas();
      final original = recetas.firstWhere((r) => r['nombre'] == 'Bocadillo');
      final id = original['id'];

      final datosActualizados = {
        'nombre': 'Bocadillo de jamón',
        'ingredientes': 'pan, jamón',
        'instrucciones': 'Paso 1: añadir pan y jamon',
        'dificultad': 2,
        'tipo_comida': 'salado',
      };

      await ApiService.actualizarReceta(id, datosActualizados);

      final recetasActualizadas = await ApiService.obtenerRecetas();
      final actualizada = recetasActualizadas.firstWhere((r) => r['id'] == id);

      expect(actualizada['nombre'], 'Bocadillo de jamón');
    });

    //Test para eliminar una receta
    test('Eliminar receta', () async {
      final receta = Recipe(
        name: 'A borrar',
        ingredients: ['azúcar'],
        instructions: 'Nada',
        difficulty: 1,
        foodType: 'dulce',
        createdAt: DateTime.now(),
      );
      await ApiService.crearReceta(receta.toJson());
      final recetas = await ApiService.obtenerRecetas();
      final creada = recetas.firstWhere((r) => r['nombre'] == 'A borrar');
      final id = creada['id'];

      await ApiService.eliminarReceta(id);

      final recetasTrasEliminar = await ApiService.obtenerRecetas();
      final existe = recetasTrasEliminar.any((r) => r['id'] == id);

      expect(existe, false);
    });
  });
}
