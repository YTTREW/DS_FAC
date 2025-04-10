abstract class LanguageModelStrategy {
  String get modelName;
  Future<String> generateResponse(String input);
}
