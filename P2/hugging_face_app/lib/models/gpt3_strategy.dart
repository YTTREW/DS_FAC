import 'language_model_strategy.dart';
import 'hugging_face_api.dart';

class GPT3Strategy implements LanguageModelStrategy {
  final HuggingFaceAPI api;
  static const String _model = 'EleutherAI/gpt-neo-2.7B';

  GPT3Strategy(this.api);

  @override
  String get modelName => _model;

  @override
  Future<String> generateResponse(String input) {
    return api.sendRequest(modelName, input);
  }
}
