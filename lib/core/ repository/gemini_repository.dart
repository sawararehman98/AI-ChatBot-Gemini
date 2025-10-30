import '../data/services/gemini_service.dart';

class GeminiRepository {
  final GeminiService _geminiService = GeminiService();

  Future<String> getGeminiResponse(String prompt) async {
    try {
      final result = await _geminiService.generateText(prompt);
      if (result.text.isEmpty) {
        return "Gemini returned an empty response.";
      }
      return result.text;
    } catch (e) {
      return " Error: ${e.toString()}";
    }
  }
}
