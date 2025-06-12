import 'package:flutter_test/flutter_test.dart';
import 'package:practica4/models/recipe.dart';
import 'package:practica4/services/api_service.dart';

void main() {
  group('RF2: Estructura de Datos de Receta', () {
    test(
      'Debe manejar recetas con la estructura especificada en el modelo',
      () {
        // Arrange & Act - Crear receta con estructura RF2
        final receta = Recipe(
          name: 'Tortilla Española', // String
          ingredients: ['patatas', 'huevos', 'aceite', 'sal'], // List<String>
          instructions:
              'Pelar patatas, freír, batir huevos, mezclar y cuajar', // String
          difficulty: 5, // int
          foodType: 'salado', // String
          createdAt: DateTime.now(), // DateTime
          id: 123, // dynamic
        );

        // Assert - Verificar tipos según RF2
        expect(receta.name, isA<String>());
        expect(receta.name, equals('Tortilla Española'));

        expect(receta.ingredients, isA<List<String>>());
        expect(receta.ingredients, hasLength(4));
        expect(receta.ingredients, contains('patatas'));
        expect(receta.ingredients, contains('huevos'));

        expect(receta.instructions, isA<String>());
        expect(receta.instructions, contains('freír'));

        expect(receta.difficulty, isA<int>());
        expect(receta.difficulty, equals(5));

        expect(receta.foodType, isA<String>());
        expect(receta.foodType, isIn(['dulce', 'salado']));

        expect(receta.createdAt, isA<DateTime>());
        expect(
          receta.createdAt.isBefore(DateTime.now().add(Duration(seconds: 1))),
          isTrue,
        );

        expect(receta.id, isA<dynamic>());
        expect(receta.id, equals(123));
      },
    );

    test('Debe serializar correctamente a JSON con el formato del backend', () {
      final receta = Recipe(
        name: 'Gazpacho Andaluz',
        ingredients: ['tomate', 'pepino', 'pimiento', 'ajo', 'aceite'],
        instructions: 'Triturar todos los ingredientes y enfriar',
        difficulty: 2,
        foodType: 'salado',
        createdAt: DateTime(2025, 6, 12, 14, 30, 0), // Fecha fija para test
        id: 456,
      );

      // Act - Serializar a JSON
      final json = receta.toJson();

      // Assert - Verificar estructura JSON según lo que espera el backend
      expect(json, isA<Map<String, dynamic>>());
      expect(json['nombre'], equals('Gazpacho Andaluz'));

      // Verificar que ingredientes se serializa como String separado por comas
      expect(json['ingredientes'], isA<String>());
      expect(json['ingredientes'], equals('tomate,pepino,pimiento,ajo,aceite'));

      expect(
        json['instrucciones'],
        equals('Triturar todos los ingredientes y enfriar'),
      );
      expect(json['dificultad'], equals(2));
      expect(json['tipo_comida'], equals('salado'));
      expect(json['created_at'], isA<String>());

      // Verificar que el ID se incluye cuando no es null
      expect(json['id'], equals(456));
      expect(json['id'], isNotNull);

      // Verificar formato de fecha ISO
      expect(json['created_at'], contains('2025-06-12'));
    });

    test('Debe serializar correctamente sin ID cuando es null', () {
      final recetaSinId = Recipe(
        name: 'Receta Sin ID',
        ingredients: ['ingrediente1'],
        instructions: 'Instrucciones',
        difficulty: 1,
        foodType: 'salado',
        createdAt: DateTime(2025, 6, 12, 14, 30, 0),
        // id es null por defecto
      );

      final json = recetaSinId.toJson();

      // Verificar que no incluye el campo 'id'
      expect(json.containsKey('id'), isFalse);
      expect(json['nombre'], equals('Receta Sin ID'));
      expect(json['ingredientes'], equals('ingrediente1'));
    });

    test('Debe deserializar correctamente desde JSON del backend', () {
      // Arrange - JSON como lo devuelve el backend
      final jsonDelBackend = {
        'id': 789,
        'nombre': 'Paella Mixta',
        'ingredientes':
            'arroz,pollo,mariscos,verduras,azafrán', // String del backend
        'instrucciones': 'Sofreír, añadir arroz y caldo, cocinar 20 minutos',
        'dificultad': 7,
        'tipo_comida': 'salado',
        'created_at': '2025-06-12T14:30:00Z',
      };

      // Act - Deserializar desde JSON
      final receta = Recipe.fromJson(jsonDelBackend);

      // Assert - Verificar que mantiene la estructura del modelo
      expect(receta.id, equals(789));
      expect(receta.name, equals('Paella Mixta'));

      // Verificar que ingredientes se convierte de String a List<String>
      expect(receta.ingredients, isA<List<String>>());
      expect(receta.ingredients, hasLength(5));
      expect(receta.ingredients, contains('arroz'));
      expect(receta.ingredients, contains('azafrán'));

      expect(
        receta.instructions,
        equals('Sofreír, añadir arroz y caldo, cocinar 20 minutos'),
      );
      expect(receta.difficulty, equals(7));
      expect(receta.foodType, equals('salado'));
      expect(receta.createdAt, isA<DateTime>());
      expect(receta.createdAt.year, equals(2025));
    });

    test('Debe mantener integridad en serialización round-trip', () {
      // Arrange - Receta original
      final recetaOriginal = Recipe(
        name: 'Crema Catalana',
        ingredients: ['leche', 'huevos', 'azúcar', 'maizena', 'canela'],
        instructions:
            'Calentar leche, batir huevos con azúcar, espesar y gratinar',
        difficulty: 6,
        foodType: 'dulce',
        createdAt: DateTime(2025, 6, 12, 15, 0, 0),
        id: 999,
      );

      // Act - Serializar y deserializar (round-trip)
      final json = recetaOriginal.toJson();
      final recetaDeserializada = Recipe.fromJson(json);

      // Assert - Verificar que los datos se mantienen
      expect(recetaDeserializada.name, equals(recetaOriginal.name));
      expect(
        recetaDeserializada.ingredients,
        equals(recetaOriginal.ingredients),
      );
      expect(
        recetaDeserializada.instructions,
        equals(recetaOriginal.instructions),
      );
      expect(recetaDeserializada.difficulty, equals(recetaOriginal.difficulty));
      expect(recetaDeserializada.foodType, equals(recetaOriginal.foodType));
      expect(recetaDeserializada.id, equals(recetaOriginal.id));

      // Verificar que las fechas son equivalentes (pueden diferir en microsegundos)
      expect(
        recetaDeserializada.createdAt
            .difference(recetaOriginal.createdAt)
            .abs()
            .inSeconds,
        lessThan(1),
      );
    });

    test('Debe manejar campos opcionales y valores nulos correctamente', () {
      // Arrange - JSON con campos opcionales/nulos
      final jsonIncompleto = {
        'id': null,
        'nombre': 'Receta Básica',
        'ingredientes': 'sal,agua',
        'instrucciones': '',
        'dificultad': 1,
        'tipo_comida': 'salado',
        'created_at': null,
      };

      // Act - Deserializar JSON incompleto
      final receta = Recipe.fromJson(jsonIncompleto);

      // Assert - Verificar manejo de valores nulos y opcionales
      expect(receta.id, isNull);
      expect(receta.name, equals('Receta Básica'));
      expect(receta.ingredients, equals(['sal', 'agua']));
      expect(receta.instructions, equals(''));
      expect(receta.difficulty, equals(1));
      expect(receta.foodType, equals('salado'));
      expect(
        receta.createdAt,
        isA<DateTime>(),
      ); // Debe usar DateTime.now() como fallback
    });

    test('Debe validar tipos de datos con valores extremos', () {
      // Arrange - Receta con valores extremos pero válidos
      final recetaExtrema = Recipe(
        name: 'A' * 100, // Nombre muy largo
        ingredients: List.generate(
          20,
          (i) => 'ingrediente$i',
        ), // Muchos ingredientes
        instructions: 'B' * 1000, // Instrucciones muy largas
        difficulty: 10, // Dificultad máxima
        foodType: 'dulce',
        createdAt: DateTime(1900, 1, 1), // Fecha muy antigua
        id: 2147483647, // Número muy grande
      );

      // Act & Assert - Verificar que maneja valores extremos
      expect(recetaExtrema.name.length, equals(100));
      expect(recetaExtrema.ingredients, hasLength(20));
      expect(recetaExtrema.instructions.length, equals(1000));
      expect(recetaExtrema.difficulty, equals(10));
      expect(recetaExtrema.createdAt.year, equals(1900));
      expect(recetaExtrema.id, equals(2147483647));

      // Verificar que se serializa correctamente
      final json = recetaExtrema.toJson();
      expect(json['ingredientes'].split(','), hasLength(20));

      // Verificar que se deserializa correctamente
      final recetaDeserializada = Recipe.fromJson(json);
      expect(recetaDeserializada.ingredients, hasLength(20));
    });

    test('Debe integrarse correctamente con el backend API', () async {
      // Arrange - Crear receta con todos los tipos de datos
      final recetaCompleta = Recipe(
        name: 'Test Integración RF2',
        ingredients: ['ingrediente1', 'ingrediente2', 'ingrediente3'],
        instructions: 'Instrucciones de prueba para verificar integración',
        difficulty: 4,
        foodType: 'salado',
        createdAt: DateTime.now(),
      );

      // Act - Enviar al backend y recuperar
      final resultadoCreacion = await ApiService.crearReceta(
        recetaCompleta.toJson(),
      );
      final id = resultadoCreacion['id'];

      // Assert - Verificar que el backend mantiene la estructura
      expect(resultadoCreacion['nombre'], equals('Test Integración RF2'));
      expect(resultadoCreacion['ingredientes'], isA<String>());
      expect(
        resultadoCreacion['ingredientes'],
        equals('ingrediente1,ingrediente2,ingrediente3'),
      );
      expect(
        resultadoCreacion['instrucciones'],
        equals('Instrucciones de prueba para verificar integración'),
      );
      expect(resultadoCreacion['dificultad'], equals(4));
      expect(resultadoCreacion['tipo_comida'], equals('salado'));
      expect(resultadoCreacion['created_at'], isA<String>());
      expect(resultadoCreacion['id'], isNotNull);

      // Verificar que se puede deserializar correctamente
      final recetaDelBackend = Recipe.fromJson(resultadoCreacion);
      expect(recetaDelBackend.name, equals(recetaCompleta.name));
      expect(recetaDelBackend.ingredients, equals(recetaCompleta.ingredients));
      expect(recetaDelBackend.difficulty, equals(recetaCompleta.difficulty));

      // Limpiar
      await ApiService.eliminarReceta(id);
    });

    test('Debe manejar diferentes formatos de ingredientes del backend', () {
      // Test para ingredientes con espacios
      final jsonConEspacios = {
        'id': 100,
        'nombre': 'Test Espacios',
        'ingredientes': 'harina , huevos , azúcar', // Con espacios
        'instrucciones': 'Test',
        'dificultad': 1,
        'tipo_comida': 'dulce',
        'created_at': '2025-06-12T10:00:00Z',
      };

      final recetaConEspacios = Recipe.fromJson(jsonConEspacios);

      // Debe limpiar espacios automáticamente
      expect(
        recetaConEspacios.ingredients,
        equals(['harina', 'huevos', 'azúcar']),
      );

      // Test para ingredientes vacíos
      final jsonVacio = {
        'id': 101,
        'nombre': 'Test Vacío',
        'ingredientes': '',
        'instrucciones': 'Test',
        'dificultad': 1,
        'tipo_comida': 'salado',
        'created_at': '2025-06-12T10:00:00Z',
      };

      final recetaVacia = Recipe.fromJson(jsonVacio);
      expect(recetaVacia.ingredients, isEmpty);
    });
  });
}
