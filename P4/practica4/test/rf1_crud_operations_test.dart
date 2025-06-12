import 'package:flutter_test/flutter_test.dart';
import 'package:practica4/models/recipe.dart';
import 'package:practica4/services/api_service.dart';

void main() {
  group('RF1: Gestión Completa de Recetas (CRUD)', () {
    group('RF1.1: Crear Receta', () {
      test('Debe crear una receta con todos los atributos requeridos', () async {
        // Arrange - Datos requeridos según RF1.1
        final receta = Recipe(
          name: 'Paella Valenciana',
          ingredients: ['arroz', 'pollo', 'verduras', 'azafrán'],
          instructions:
              'Calentar aceite, sofreír pollo, añadir arroz y caldo, cocinar 20 minutos',
          difficulty: 6,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        // Act - Crear receta
        final resultado = await ApiService.crearReceta(receta.toJson());

        // Assert - Criterio de aceptación: debe ser almacenada
        expect(resultado, isA<Map<String, dynamic>>());
        expect(resultado['id'], isNotNull);
        expect(resultado['nombre'], equals('Paella Valenciana'));

        // Verificar tipos específicos que usa el backend
        expect(resultado['ingredientes'], isA<String>());
        expect(
          resultado['ingredientes'],
          equals('arroz,pollo,verduras,azafrán'),
        );
        expect(resultado['instrucciones'], isA<String>());
        expect(
          resultado['instrucciones'],
          equals(
            'Calentar aceite, sofreír pollo, añadir arroz y caldo, cocinar 20 minutos',
          ),
        );
        expect(resultado['dificultad'], isA<int>());
        expect(resultado['dificultad'], equals(6));
        expect(resultado['tipo_comida'], isA<String>());
        expect(resultado['tipo_comida'], equals('salado'));
        expect(resultado['created_at'], isA<String>());

        expect(resultado['nombre'], equals('Paella Valenciana'));
      });

      test(
        'Debe validar que todos los campos requeridos estén presentes',
        () async {
          final recetaCompleta = Recipe(
            name: 'Tarta de Chocolate',
            ingredients: ['harina', 'chocolate', 'huevos', 'azúcar'],
            instructions:
                'Mezclar ingredientes, hornear a 180°C durante 45 minutos',
            difficulty: 4,
            foodType: 'dulce',
            createdAt: DateTime.now(),
          );

          final resultado = await ApiService.crearReceta(
            recetaCompleta.toJson(),
          );

          expect(resultado['nombre'], isNotNull);
          expect(resultado['nombre'], isA<String>());

          expect(resultado['ingredientes'], isA<String>());
          expect(
            resultado['ingredientes'],
            equals('harina,chocolate,huevos,azúcar'),
          );
          expect(resultado['ingredientes'], contains('harina'));
          expect(resultado['ingredientes'], contains('chocolate'));

          expect(resultado['instrucciones'], isA<String>());
          expect(resultado['instrucciones'], isNotNull);
          expect(resultado['dificultad'], isA<int>());
          expect(resultado['dificultad'], equals(4));
          expect(resultado['tipo_comida'], isA<String>());
          expect(resultado['tipo_comida'], isIn(['dulce', 'salado']));
          expect(resultado['created_at'], isA<String>());
          expect(resultado['created_at'], isNotNull);
          expect(resultado['id'], isNotNull);
        },
      );
    });

    group('RF1.2: Obtener Recetas', () {
      test('Debe recuperar todas las recetas almacenadas', () async {
        // Act - Obtener recetas
        final recetas = await ApiService.obtenerRecetas();

        // Assert - Criterio de aceptación: lista dinámica
        expect(recetas, isA<List<Map<String, dynamic>>>());

        // Verificar formato según RF1.2
        if (recetas.isNotEmpty) {
          final primeraReceta = recetas.first;
          expect(primeraReceta, contains('id'));
          expect(primeraReceta, contains('nombre'));
          expect(primeraReceta, contains('ingredientes'));
          expect(primeraReceta, contains('instrucciones'));
          expect(primeraReceta, contains('dificultad'));
          expect(primeraReceta, contains('tipo_comida'));
          expect(primeraReceta, contains('created_at'));
        }
      });

      test('Debe retornar lista vacía cuando no hay recetas', () async {
        // Eliminar todas las recetas primero
        final recetas = await ApiService.obtenerRecetas();
        for (final receta in recetas) {
          await ApiService.eliminarReceta(receta['id']);
        }

        // Verificar lista vacía
        final recetasVacias = await ApiService.obtenerRecetas();
        expect(recetasVacias, isEmpty);
      });
    });

    group('RF1.3: Actualizar Receta', () {
      test('Debe modificar todos los datos de una receta existente', () async {
        // Usar nombres únicos para evitar conflictos
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final recetaInicial = Recipe(
          name: 'Ensalada Simple $timestamp',
          ingredients: ['lechuga', 'tomate'],
          instructions: 'Lavar y cortar verduras',
          difficulty: 1,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        final recetaCreada = await ApiService.crearReceta(
          recetaInicial.toJson(),
        );
        final id = recetaCreada['id'];

        // Verificar que la receta se creó correctamente antes de continuar
        expect(id, isNotNull);
        expect(recetaCreada['nombre'], equals('Ensalada Simple $timestamp'));

        try {
          // Act - Actualizar según RF1.3 funcionalidades
          final datosActualizados = {
            'nombre': 'Ensalada César Completa $timestamp',
            'ingredientes': 'lechuga,tomate,cebolla,queso,croutons',
            'instrucciones':
                'Lavar verduras, cortar, añadir queso y croutons, aliñar',
            'dificultad': 3,
            'tipo_comida': 'salado',
          };

          final recetaActualizada = await ApiService.actualizarReceta(
            id,
            datosActualizados,
          );

          // Assert - Criterio de aceptación: cambios deben persistir
          expect(
            recetaActualizada['nombre'],
            equals('Ensalada César Completa $timestamp'),
          );
          expect(recetaActualizada['ingredientes'], isA<String>());
          expect(
            recetaActualizada['ingredientes'],
            equals('lechuga,tomate,cebolla,queso,croutons'),
          );

          final ingredientesSeparados = recetaActualizada['ingredientes'].split(
            ',',
          );
          expect(ingredientesSeparados, hasLength(5));
          expect(ingredientesSeparados, contains('lechuga'));
          expect(ingredientesSeparados, contains('croutons'));
          expect(recetaActualizada['dificultad'], equals(3));
          expect(recetaActualizada['instrucciones'], contains('aliñar'));

          // Verificar persistencia de forma más robusta
          await Future.delayed(
            Duration(milliseconds: 100),
          ); // Pequeña pausa para asegurar persistencia

          final recetas = await ApiService.obtenerRecetas();
          final recetaPersistida = recetas.where((r) => r['id'] == id).toList();

          expect(
            recetaPersistida,
            hasLength(1),
            reason: 'Debe existir exactamente una receta con ese ID',
          );
          expect(
            recetaPersistida.first['nombre'],
            equals('Ensalada César Completa $timestamp'),
          );
        } finally {
          // Asegurar limpieza incluso si el test falla
          try {
            await ApiService.eliminarReceta(id);
          } catch (e) {
            // Ignorar errores de eliminación, ya que el test puede fallar antes
            // de llegar a este punto.
          }
        }
      });
    });

    group('RF1.4: Eliminar Receta', () {
      test('Debe eliminar receta y no aparecer en futuras consultas', () async {
        // Arrange - Crear receta para eliminar
        final recetaTemporal = Recipe(
          name: 'Receta para Eliminar',
          ingredients: ['ingrediente1'],
          instructions: 'Instrucciones temporales',
          difficulty: 1,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        final recetaCreada = await ApiService.crearReceta(
          recetaTemporal.toJson(),
        );
        final id = recetaCreada['id'];

        // Verificar que existe antes de eliminar
        final recetasAntes = await ApiService.obtenerRecetas();
        final existeAntes = recetasAntes.any((r) => r['id'] == id);
        expect(existeAntes, isTrue);

        // Act - Eliminar receta
        await ApiService.eliminarReceta(id);

        // Assert - Criterio de aceptación: no debe aparecer en futuras consultas
        final recetasDespues = await ApiService.obtenerRecetas();
        final existeDespues = recetasDespues.any((r) => r['id'] == id);
        expect(
          existeDespues,
          isFalse,
          reason: 'La receta eliminada no debe aparecer en consultas futuras',
        );
      });
    });
  });
}
