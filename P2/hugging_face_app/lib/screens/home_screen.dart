import 'package:flutter/material.dart';
import '../models/hugging_face_api.dart';
import '../widgets/response_display.dart';
import '../models/language_model_strategy.dart';
import '../models/gpt2_strategy.dart';
import '../models/gpt3_strategy.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HuggingFaceAPI api = HuggingFaceAPI();
  late LanguageModelStrategy selectedStrategy;
  String response = '';
  final TextEditingController controller = TextEditingController();

  bool isLoading = false;

  // Inicializa los modelo de lenguaje
  GPT2Strategy gpt2Strategy = GPT2Strategy(HuggingFaceAPI());
  GPT3Strategy gpt3Strategy = GPT3Strategy(HuggingFaceAPI());

  @override
  void initState() {
    super.initState();
    // Inicializa el valor por defecto
    selectedStrategy = gpt2Strategy;
  }

  // Método para obtener la respuesta de la estrategia seleccionada
  void _getResponse() async {
    setState(() {
      isLoading = true;
      response = ''; // limpia la respuesta anterior si quieres
    });

    String inputMessage = controller.text;
    String result = await selectedStrategy.generateResponse(inputMessage);

    setState(() {
      response = result;
      isLoading = false;
    });
  }

  // Método para cambiar la estrategia según la selección
  void _updateStrategy(LanguageModelStrategy strategy) {
    setState(() {
      selectedStrategy = strategy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hugging Face LLM Selector')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown que selecciona el modelo de lenguaje
            DropdownButton<LanguageModelStrategy>(
              value: selectedStrategy,
              items: [
                DropdownMenuItem(
                  value:
                      selectedStrategy is GPT2Strategy
                          ? selectedStrategy
                          : gpt2Strategy,
                  child: Text('GPT-2'),
                ),
                DropdownMenuItem(
                  value:
                      selectedStrategy is GPT3Strategy
                          ? selectedStrategy
                          : gpt3Strategy,
                  child: Text('GPT-3'),
                ),
              ],
              onChanged: (LanguageModelStrategy? value) {
                if (value != null) {
                  _updateStrategy(value); // Cambiar la estrategia seleccionada
                }
              },
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Enter your message'),
            ),
            SizedBox(height: 10),
            Center(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _getResponse,
                        child: const Text('Send Message'),
                      ),
            ),
            SizedBox(height: 20),
            ResponseDisplay(response: response, isLoading: isLoading),
          ],
        ),
      ),
    );
  }
}
