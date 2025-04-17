import 'language_model_strategy.dart';
import 'hugging_face_api.dart';

class GPT2Strategy implements LanguageModelStrategy {
  final HuggingFaceAPI _api;
  static const String _model = 'gpt2';

  GPT2Strategy(this._api);

  @override
  String get modelName => _model;

  @override
  Future<String> generateResponse(String input) {
    return _api.sendRequest(modelName, input);
  }
}
