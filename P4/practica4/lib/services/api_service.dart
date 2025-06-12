import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Despliegue en Android Emulator
  static const String baseUrl =
      'http://localhost:3000'; // Despliegue en navegador

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET - Obtener recetas de la BD
  static Future<List<Map<String, dynamic>>> obtenerRecetas() async {
    try {
      final url = Uri.parse('$baseUrl/recetas');
      final response = await http
          .get(url, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // Re-lanzar el error para que el Provider lo maneje
      rethrow;
    }
  }

  // POST - Crear una receta en la BD
  static Future<Map<String, dynamic>> crearReceta(
    Map<String, dynamic> receta,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/recetas');
      final response = await http
          .post(url, headers: _headers, body: jsonEncode({'receta': receta}))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error al crear receta HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // PUT - Actualizar una receta en la BD (Rails usa PUT, no PATCH)
  static Future<Map<String, dynamic>> actualizarReceta(
    int id,
    Map<String, dynamic> receta,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/recetas/$id');
      final response = await http
          .put(url, headers: _headers, body: jsonEncode({'receta': receta}))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error al actualizar receta HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // DELETE - Eliminar una receta de la BD
  static Future<void> eliminarReceta(int id) async {
    try {
      final url = Uri.parse('$baseUrl/recetas/$id');
      final response = await http
          .delete(url, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
          'Error al eliminar receta HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> verificarConexion() async {
    try {
      final url = Uri.parse('$baseUrl/recetas');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> obtenerReceta(int id) async {
    try {
      final url = Uri.parse('$baseUrl/recetas/$id');
      final response = await http
          .get(url, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error al obtener receta HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
