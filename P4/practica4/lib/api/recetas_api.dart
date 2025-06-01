import 'package:http/http.dart' as http;
import 'dart:convert';

class RecetaApi {
  static const String baseUrl = 'http://localhost:3000'; // conexion URL

  // GET - Obtener recetas de la BD
  static Future<List<dynamic>> obtenerRecetas() async {
    final url = Uri.parse('$baseUrl/recetas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar las recetas');
    }
  }

  // POST - Crear una receta en la BD
  static Future<void> crearReceta(Map<String, dynamic> receta) async {
    final url = Uri.parse('$baseUrl/recetas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'receta': receta}),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear una nueva receta: ${response.body}');
    }
  }

  // DELETE - Eliminar una receta de la BD
  static Future<void> eliminarReceta(int id) async {
    final url = Uri.parse('$baseUrl/recetas/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la receta: ${response.body}');
    }
  }

  // PATCH - Actualizar una receta en la BD
  static Future<void> actualizarReceta(int id, Map<String, dynamic> receta) async {
    final url = Uri.parse('$baseUrl/recetas/$id');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'receta': receta}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la receta: ${response.body}');
    }
  }
}
