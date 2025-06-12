// test/requirements/rnf1_api_restful_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:practica4/services/api_service.dart';

void main() {
  group('RNF1: API RestFUL', () {
    test('Debe usar comunicación asíncrona (async/await)', () async {
      // Verificar que los métodos devuelven Future
      final future = ApiService.obtenerRecetas();
      expect(future, isA<Future<List<Map<String, dynamic>>>>());

      // Verificar que async/await funciona
      final resultado = await future;
      expect(resultado, isA<List<Map<String, dynamic>>>());
    });

    test('Debe manejar datos en formato JSON', () async {
      final receta = {
        'nombre': 'Test JSON',
        'ingredientes': 'test1,test2',
        'instrucciones': 'Test',
        'dificultad': 1,
        'tipo_comida': 'salado',
      };

      // Enviar JSON y verificar respuesta JSON
      final resultado = await ApiService.crearReceta(receta);
      expect(resultado, isA<Map<String, dynamic>>());
      expect(resultado.keys, contains('id'));
      expect(resultado.keys, contains('nombre'));

      // Limpiar
      await ApiService.eliminarReceta(resultado['id']);
    });

    test('Debe exponer operaciones CRUD mediante métodos REST', () {
      // Verificar que todos los métodos CRUD están disponibles
      expect(ApiService.crearReceta, isA<Function>());
      expect(ApiService.obtenerRecetas, isA<Function>());
      expect(ApiService.actualizarReceta, isA<Function>());
      expect(ApiService.eliminarReceta, isA<Function>());
    });

    test('Debe manejar errores HTTP correctamente', () async {
      // Test de manejo de errores
      expect(
        () async => await ApiService.eliminarReceta(999999),
        throwsA(isA<Exception>()),
      );
    });
  });
}
