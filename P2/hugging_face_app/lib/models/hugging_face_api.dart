import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hugging_face_app/secrets/secrets.dart';

class HuggingFaceAPI {
  final String _apiUrl = huggingFaceModel;
  final String _token = huggingFaceToken;

  Future<String> sendRequest(String modelName, String inputMessage) async {
    final url = Uri.parse('$_apiUrl$modelName');
    final headers = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    };
    final body = json.encode({"inputs": inputMessage});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = json.decode(responseBody);
      return responseData[0]['generated_text'] ?? 'No response';
    } else {
      return 'Error: ${response.statusCode} - ${response.body}';
    }
  }
}
