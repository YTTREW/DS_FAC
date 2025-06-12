// test/requirements/rf3_business_rules_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:practica4/models/recipe.dart';
import 'package:practica4/services/api_service.dart';

void main() {
  group('RF3: Validaciones y Reglas de Negocio', () {
    group('RF3.1: ID único generado por el sistema', () {
      test('Cada receta debe tener un ID único', () async {
        // Arrange - Crear múltiples recetas
        final receta1 = Recipe(
          name: 'Receta Única 1',
          ingredients: ['ingrediente1'],
          instructions: 'Instrucciones 1',
          difficulty: 1,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        final receta2 = Recipe(
          name: 'Receta Única 2',
          ingredients: ['ingrediente2'],
          instructions: 'Instrucciones 2',
          difficulty: 2,
          foodType: 'dulce',
          createdAt: DateTime.now(),
        );

        // Act - Crear las recetas
        final resultado1 = await ApiService.crearReceta(receta1.toJson());
        final resultado2 = await ApiService.crearReceta(receta2.toJson());

        // Assert - Verificar IDs únicos
        expect(resultado1['id'], isNotNull);
        expect(resultado2['id'], isNotNull);
        expect(resultado1['id'], isNot(equals(resultado2['id'])));

        // Verificar que los IDs son de tipo correcto
        expect(resultado1['id'], isA<int>());
        expect(resultado2['id'], isA<int>());

        // Limpiar
        await ApiService.eliminarReceta(resultado1['id']);
        await ApiService.eliminarReceta(resultado2['id']);
      });

      test('El sistema debe generar el ID automáticamente', () async {
        // Arrange - Receta sin ID especificado
        final recetaSinId = Recipe(
          name: 'Receta Sin ID Manual',
          ingredients: ['ingrediente'],
          instructions: 'Instrucciones sin ID',
          difficulty: 1,
          foodType: 'salado',
          createdAt: DateTime.now(),
          // No especificamos ID - debe ser null
        );

        // Verificar que la receta no tiene ID antes de enviar
        expect(recetaSinId.id, isNull);

        // Act - Crear receta
        final resultado = await ApiService.crearReceta(recetaSinId.toJson());

        // Assert - El sistema debe asignar un ID automáticamente
        expect(resultado['id'], isNotNull);
        expect(resultado['id'], isA<int>());
        expect(resultado['id'], greaterThan(0));

        // Limpiar
        await ApiService.eliminarReceta(resultado['id']);
      });

      test(
        'Los IDs deben ser secuenciales y únicos en múltiples creaciones',
        () async {
          // Arrange - Lista para almacenar IDs
          final ids = <int>[];
          final recetasCreadas = <Map<String, dynamic>>[];

          try {
            // Act - Crear 5 recetas consecutivas
            for (int i = 1; i <= 5; i++) {
              final receta = Recipe(
                name: 'Receta Secuencial $i',
                ingredients: ['ingrediente$i'],
                instructions: 'Instrucciones $i',
                difficulty: i,
                foodType: i % 2 == 0 ? 'dulce' : 'salado',
                createdAt: DateTime.now(),
              );

              final resultado = await ApiService.crearReceta(receta.toJson());
              recetasCreadas.add(resultado);
              ids.add(resultado['id']);
            }

            // Assert - Verificar que todos los IDs son únicos
            final idsUnicos = ids.toSet();
            expect(
              idsUnicos.length,
              equals(ids.length),
              reason: 'Todos los IDs deben ser únicos',
            );

            // Verificar que todos los IDs son válidos
            for (final id in ids) {
              expect(id, isA<int>());
              expect(id, greaterThan(0));
            }

            // Verificar que los IDs están en orden creciente
            for (int i = 1; i < ids.length; i++) {
              expect(
                ids[i],
                greaterThan(ids[i - 1]),
                reason: 'Los IDs deben ser secuenciales',
              );
            }
          } finally {
            // Limpiar todas las recetas creadas
            for (final receta in recetasCreadas) {
              await ApiService.eliminarReceta(receta['id']);
            }
          }
        },
      );

      test('El ID debe persistir después de operaciones CRUD', () async {
        // Arrange - Crear receta
        final recetaOriginal = Recipe(
          name: 'Receta Persistencia ID',
          ingredients: ['ingrediente'],
          instructions: 'Test persistencia',
          difficulty: 3,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        final recetaCreada = await ApiService.crearReceta(
          recetaOriginal.toJson(),
        );
        final idOriginal = recetaCreada['id'];

        // Act - Actualizar receta
        final datosActualizados = {
          'nombre': 'Receta Actualizada',
          'ingredientes': 'nuevo_ingrediente',
          'instrucciones': 'Nuevas instrucciones',
          'dificultad': 5,
          'tipo_comida': 'dulce',
        };

        final recetaActualizada = await ApiService.actualizarReceta(
          idOriginal,
          datosActualizados,
        );

        // Assert - El ID debe mantenerse igual
        expect(recetaActualizada['id'], equals(idOriginal));

        // Verificar en la lista de recetas
        final todasLasRecetas = await ApiService.obtenerRecetas();
        final recetaEnLista = todasLasRecetas.firstWhere(
          (r) => r['id'] == idOriginal,
        );
        expect(recetaEnLista['id'], equals(idOriginal));
        expect(recetaEnLista['nombre'], equals('Receta Actualizada'));

        // Limpiar
        await ApiService.eliminarReceta(idOriginal);
      });
    });

    group('RF3.2: Búsqueda por nombre exacto', () {
      test('Debe permitir buscar recetas por nombre exacto', () async {
        // Arrange - Crear recetas con nombres específicos
        final recetaBuscable1 = Recipe(
          name: 'Arroz con Leche Tradicional',
          ingredients: ['arroz', 'leche', 'azúcar', 'canela'],
          instructions: 'Cocer arroz con leche hasta espesar',
          difficulty: 3,
          foodType: 'dulce',
          createdAt: DateTime.now(),
        );

        final recetaBuscable2 = Recipe(
          name: 'Paella Valenciana',
          ingredients: ['arroz', 'pollo', 'verduras'],
          instructions: 'Cocinar arroz con pollo',
          difficulty: 6,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        final resultado1 = await ApiService.crearReceta(
          recetaBuscable1.toJson(),
        );
        final resultado2 = await ApiService.crearReceta(
          recetaBuscable2.toJson(),
        );

        try {
          // Act - Buscar por nombre exacto
          final todasLasRecetas = await ApiService.obtenerRecetas();

          final recetaEncontrada1 =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'Arroz con Leche Tradicional')
                  .toList();

          final recetaEncontrada2 =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'Paella Valenciana')
                  .toList();

          // Assert - Debe encontrar exactamente una receta de cada una
          expect(recetaEncontrada1, hasLength(1));
          expect(
            recetaEncontrada1.first['nombre'],
            equals('Arroz con Leche Tradicional'),
          );
          expect(recetaEncontrada1.first['id'], equals(resultado1['id']));

          expect(recetaEncontrada2, hasLength(1));
          expect(
            recetaEncontrada2.first['nombre'],
            equals('Paella Valenciana'),
          );
          expect(recetaEncontrada2.first['id'], equals(resultado2['id']));
        } finally {
          // Limpiar
          await ApiService.eliminarReceta(resultado1['id']);
          await ApiService.eliminarReceta(resultado2['id']);
        }
      });

      test('La búsqueda debe ser sensible a mayúsculas/minúsculas', () async {
        // Arrange - Crear receta con nombre específico
        final recetaConMayusculas = Recipe(
          name: 'Tortilla Española Casera',
          ingredients: ['patatas', 'huevos', 'aceite'],
          instructions: 'Freír patatas y cuajar con huevos',
          difficulty: 4,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        final recetaCreada = await ApiService.crearReceta(
          recetaConMayusculas.toJson(),
        );

        try {
          // Act - Buscar con diferentes variaciones de mayúsculas/minúsculas
          final todasLasRecetas = await ApiService.obtenerRecetas();

          final exacto =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'Tortilla Española Casera')
                  .length;

          final minusculas =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'tortilla española casera')
                  .length;

          final mayusculas =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'TORTILLA ESPAÑOLA CASERA')
                  .length;

          final mixto =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'tortilla Española CASERA')
                  .length;

          // Assert - Solo el nombre exacto debe coincidir
          expect(exacto, equals(1), reason: 'Debe encontrar el nombre exacto');
          expect(
            minusculas,
            equals(0),
            reason: 'No debe encontrar en minúsculas',
          );
          expect(
            mayusculas,
            equals(0),
            reason: 'No debe encontrar en mayúsculas',
          );
          expect(mixto, equals(0), reason: 'No debe encontrar mezcla de casos');
        } finally {
          // Limpiar
          await ApiService.eliminarReceta(recetaCreada['id']);
        }
      });

      test('Debe distinguir entre nombres similares', () async {
        // Arrange - Crear recetas con nombres similares pero diferentes
        final recetas = [
          Recipe(
            name: 'Paella',
            ingredients: ['arroz'],
            instructions: 'Cocinar arroz',
            difficulty: 1,
            foodType: 'salado',
            createdAt: DateTime.now(),
          ),
          Recipe(
            name: 'Paella Valenciana',
            ingredients: ['arroz', 'pollo'],
            instructions: 'Cocinar arroz con pollo',
            difficulty: 2,
            foodType: 'salado',
            createdAt: DateTime.now(),
          ),
          Recipe(
            name: 'Paella de Mariscos',
            ingredients: ['arroz', 'mariscos'],
            instructions: 'Cocinar arroz con mariscos',
            difficulty: 3,
            foodType: 'salado',
            createdAt: DateTime.now(),
          ),
        ];

        final recetasCreadas = <Map<String, dynamic>>[];

        try {
          // Crear todas las recetas
          for (final receta in recetas) {
            final resultado = await ApiService.crearReceta(receta.toJson());
            recetasCreadas.add(resultado);
          }

          // Act - Buscar cada nombre específico
          final todasLasRecetas = await ApiService.obtenerRecetas();

          final soloParella =
              todasLasRecetas.where((r) => r['nombre'] == 'Paella').toList();

          final paellaValenciana =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'Paella Valenciana')
                  .toList();

          final paellaMariscos =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'Paella de Mariscos')
                  .toList();

          // Assert - Cada búsqueda debe devolver exactamente una receta
          expect(soloParella, hasLength(1));
          expect(soloParella.first['nombre'], equals('Paella'));

          expect(paellaValenciana, hasLength(1));
          expect(paellaValenciana.first['nombre'], equals('Paella Valenciana'));

          expect(paellaMariscos, hasLength(1));
          expect(paellaMariscos.first['nombre'], equals('Paella de Mariscos'));

          // Verificar que no hay confusión entre recetas
          expect(
            soloParella.first['id'],
            isNot(equals(paellaValenciana.first['id'])),
          );
          expect(
            paellaValenciana.first['id'],
            isNot(equals(paellaMariscos.first['id'])),
          );
        } finally {
          // Limpiar todas las recetas
          for (final receta in recetasCreadas) {
            await ApiService.eliminarReceta(receta['id']);
          }
        }
      });

      test('Debe manejar nombres con caracteres especiales', () async {
        // Arrange - Recetas con caracteres especiales
        final recetasEspeciales = [
          Recipe(
            name: 'Crème Brûlée',
            ingredients: ['nata', 'azúcar'],
            instructions: 'Hacer crema y caramelizar',
            difficulty: 5,
            foodType: 'dulce',
            createdAt: DateTime.now(),
          ),
          Recipe(
            name: 'Niños Envueltos (Ñoquis)',
            ingredients: ['patata', 'harina'],
            instructions: 'Hacer masa y hervir',
            difficulty: 4,
            foodType: 'salado',
            createdAt: DateTime.now(),
          ),
        ];

        final recetasCreadas = <Map<String, dynamic>>[];

        try {
          // Crear recetas
          for (final receta in recetasEspeciales) {
            final resultado = await ApiService.crearReceta(receta.toJson());
            recetasCreadas.add(resultado);
          }

          // Act - Buscar por nombres con caracteres especiales
          final todasLasRecetas = await ApiService.obtenerRecetas();

          final cremeBrulee =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'Crème Brûlée')
                  .toList();

          final noquis =
              todasLasRecetas
                  .where((r) => r['nombre'] == 'Niños Envueltos (Ñoquis)')
                  .toList();

          // Assert - Debe encontrar los nombres exactos con caracteres especiales
          expect(cremeBrulee, hasLength(1));
          expect(cremeBrulee.first['nombre'], equals('Crème Brûlée'));

          expect(noquis, hasLength(1));
          expect(noquis.first['nombre'], equals('Niños Envueltos (Ñoquis)'));
        } finally {
          // Limpiar
          for (final receta in recetasCreadas) {
            await ApiService.eliminarReceta(receta['id']);
          }
        }
      });
    });

    group('RF3.3: Persistencia en base de datos', () {
      test('Las operaciones CRUD deben persistir en base de datos', () async {
        // Arrange - Datos iniciales
        final recetaInicial = Recipe(
          name: 'Test Persistencia CRUD',
          ingredients: ['ingrediente_inicial'],
          instructions: 'Instrucciones iniciales',
          difficulty: 2,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        // Act & Assert - CREATE y verificar persistencia
        final recetaCreada = await ApiService.crearReceta(
          recetaInicial.toJson(),
        );
        final id = recetaCreada['id'];
        expect(id, isNotNull);

        // Verificar que CREATE persistió
        var recetas = await ApiService.obtenerRecetas();
        var existe = recetas.any((r) => r['id'] == id);
        expect(existe, isTrue, reason: 'CREATE debe persistir en BD');

        // UPDATE - Actualizar y verificar persistencia
        final datosActualizados = {
          'nombre': 'Test Persistencia ACTUALIZADA',
          'ingredientes': 'ingrediente_actualizado,nuevo_ingrediente',
          'instrucciones': 'Instrucciones actualizadas',
          'dificultad': 5,
          'tipo_comida': 'dulce',
        };

        await ApiService.actualizarReceta(id, datosActualizados);

        // Verificar que UPDATE persistió
        recetas = await ApiService.obtenerRecetas();
        final recetaActualizada = recetas.firstWhere((r) => r['id'] == id);
        expect(
          recetaActualizada['nombre'],
          equals('Test Persistencia ACTUALIZADA'),
        );
        expect(recetaActualizada['dificultad'], equals(5));
        expect(recetaActualizada['tipo_comida'], equals('dulce'));
        expect(
          recetaActualizada['ingredientes'],
          contains('nuevo_ingrediente'),
        );

        // DELETE - Eliminar y verificar persistencia
        await ApiService.eliminarReceta(id);

        // Verificar que DELETE persistió
        recetas = await ApiService.obtenerRecetas();
        existe = recetas.any((r) => r['id'] == id);
        expect(existe, isFalse, reason: 'DELETE debe persistir en BD');
      });

      test(
        'Los datos deben persistir entre sesiones (simulando reinicio)',
        () async {
          // Arrange - Crear datos de prueba
          final recetasPersistentes = [
            Recipe(
              name: 'Persistencia Sesión 1',
              ingredients: ['ingrediente1'],
              instructions: 'Test persistencia 1',
              difficulty: 1,
              foodType: 'salado',
              createdAt: DateTime.now(),
            ),
            Recipe(
              name: 'Persistencia Sesión 2',
              ingredients: ['ingrediente2'],
              instructions: 'Test persistencia 2',
              difficulty: 2,
              foodType: 'dulce',
              createdAt: DateTime.now(),
            ),
          ];

          final idsCreados = <int>[];

          try {
            // Act - Crear recetas (simula sesión 1)
            for (final receta in recetasPersistentes) {
              final resultado = await ApiService.crearReceta(receta.toJson());
              idsCreados.add(resultado['id']);
            }

            // Simular "reinicio" obteniendo datos frescos
            await Future.delayed(Duration(milliseconds: 100));

            // Assert - Verificar que los datos persisten (simula sesión 2)
            final recetasTrasReinicio = await ApiService.obtenerRecetas();

            for (final id in idsCreados) {
              final recetaEncontrada =
                  recetasTrasReinicio.where((r) => r['id'] == id).toList();
              expect(
                recetaEncontrada,
                hasLength(1),
                reason: 'La receta con ID $id debe persistir tras reinicio',
              );
            }

            // Verificar datos específicos
            final receta1 = recetasTrasReinicio.firstWhere(
              (r) => r['nombre'] == 'Persistencia Sesión 1',
            );
            final receta2 = recetasTrasReinicio.firstWhere(
              (r) => r['nombre'] == 'Persistencia Sesión 2',
            );

            expect(receta1['ingredientes'], equals('ingrediente1'));
            expect(receta2['dificultad'], equals(2));
          } finally {
            // Limpiar
            for (final id in idsCreados) {
              await ApiService.eliminarReceta(id);
            }
          }
        },
      );

      test('Las transacciones deben ser atómicas (crear y fallar)', () async {
        // Arrange - Obtener estado inicial
        final recetasIniciales = await ApiService.obtenerRecetas();
        final cantidadInicial = recetasIniciales.length;

        // Act - Intentar crear receta válida
        final recetaValida = Recipe(
          name: 'Receta Válida Atomicidad',
          ingredients: ['ingrediente_valido'],
          instructions: 'Instrucciones válidas',
          difficulty: 3,
          foodType: 'salado',
          createdAt: DateTime.now(),
        );

        final recetaCreada = await ApiService.crearReceta(
          recetaValida.toJson(),
        );
        final idCreado = recetaCreada['id'];

        // Verificar que se creó
        var recetasActuales = await ApiService.obtenerRecetas();
        expect(recetasActuales.length, equals(cantidadInicial + 1));

        // Act - Intentar operación que puede fallar (eliminar ID inexistente)
        try {
          await ApiService.eliminarReceta(999999); // ID inexistente
          fail('Debería haber lanzado una excepción');
        } catch (e) {
          // Expected - debe fallar
          expect(e, isA<Exception>());
        }

        // Assert - La receta válida debe seguir existiendo
        recetasActuales = await ApiService.obtenerRecetas();
        final recetaSigueExistiendo = recetasActuales.any(
          (r) => r['id'] == idCreado,
        );
        expect(
          recetaSigueExistiendo,
          isTrue,
          reason: 'Una operación fallida no debe afectar datos válidos',
        );

        // Limpiar
        await ApiService.eliminarReceta(idCreado);
      });

      test('Los índices y relaciones deben mantenerse consistentes', () async {
        // Arrange - Crear múltiples recetas para probar consistencia
        final recetasConsistencia = <Recipe>[];
        final idsCreados = <int>[];

        for (int i = 1; i <= 10; i++) {
          recetasConsistencia.add(
            Recipe(
              name: 'Consistencia $i',
              ingredients: ['ingrediente$i'],
              instructions: 'Instrucciones $i',
              difficulty: i % 5 + 1,
              foodType: i % 2 == 0 ? 'dulce' : 'salado',
              createdAt: DateTime.now(),
            ),
          );
        }

        try {
          // Act - Crear todas las recetas
          for (final receta in recetasConsistencia) {
            final resultado = await ApiService.crearReceta(receta.toJson());
            idsCreados.add(resultado['id']);
          }

          // Verificar que todas las recetas están en BD
          final todasLasRecetas = await ApiService.obtenerRecetas();

          for (final id in idsCreados) {
            final recetaEnBD =
                todasLasRecetas.where((r) => r['id'] == id).toList();
            expect(
              recetaEnBD,
              hasLength(1),
              reason: 'Cada receta debe existir exactamente una vez',
            );
          }

          // Act - Eliminar algunas recetas (números pares)
          final idsAEliminar = idsCreados.where((id) => id % 2 == 0).toList();
          for (final id in idsAEliminar) {
            await ApiService.eliminarReceta(id);
          }

          // Assert - Verificar consistencia tras eliminaciones parciales
          final recetasTrasEliminacion = await ApiService.obtenerRecetas();

          // Las recetas eliminadas no deben existir
          for (final id in idsAEliminar) {
            final eliminada = recetasTrasEliminacion.any((r) => r['id'] == id);
            expect(
              eliminada,
              isFalse,
              reason: 'Las recetas eliminadas no deben existir',
            );
          }

          // Las recetas no eliminadas deben seguir existiendo
          final idsNoEliminados =
              idsCreados.where((id) => !idsAEliminar.contains(id)).toList();
          for (final id in idsNoEliminados) {
            final sigueExistiendo = recetasTrasEliminacion.any(
              (r) => r['id'] == id,
            );
            expect(
              sigueExistiendo,
              isTrue,
              reason: 'Las recetas no eliminadas deben seguir existiendo',
            );
          }
        } finally {
          // Limpiar recetas restantes
          final recetasFinales = await ApiService.obtenerRecetas();
          for (final receta in recetasFinales) {
            if (receta['nombre'].toString().startsWith('Consistencia')) {
              await ApiService.eliminarReceta(receta['id']);
            }
          }
        }
      });
    });
  });
}
