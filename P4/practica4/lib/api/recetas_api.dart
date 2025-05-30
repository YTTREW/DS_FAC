import 'package:http/http.dart' as http;
import 'dart:convert';

class RecetaApi {
  static const String baseUrl = 'http://localhost:3000'; // Usa esto para emulador Android

  static Future<List<dynamic>> obtenerRecetas() async {
    final url = Uri.parse('$baseUrl/recetas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar recetas');
    }
  }

  static Future<void> crearReceta(Map<String, dynamic> receta) async {
    final url = Uri.parse('$baseUrl/recetas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'receta': receta}),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear receta: ${response.body}');
    }
  }

  // Puedes agregar también update y delete si los necesitas
}
