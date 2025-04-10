import 'language_model_strategy.dart';
import 'hugging_face_api.dart';

class GPT3Strategy implements LanguageModelStrategy {
  final HuggingFaceAPI api;

  GPT3Strategy(this.api);

  @override
  String get modelName => 'EleutherAI/gpt-neo-2.7B';

  @override
  Future<String> generateResponse(String input) {
    return api.sendRequest(modelName, input);
  }
}
