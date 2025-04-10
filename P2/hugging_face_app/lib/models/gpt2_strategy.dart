import 'language_model_strategy.dart';
import 'hugging_face_api.dart';

class GPT2Strategy implements LanguageModelStrategy {
  final HuggingFaceAPI api;

  GPT2Strategy(this.api);

  @override
  String get modelName => 'gpt2';

  @override
  Future<String> generateResponse(String input) {
    return api.sendRequest(modelName, input);
  }
}
