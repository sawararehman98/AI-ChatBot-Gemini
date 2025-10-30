import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant/url_constant.dart';

class GeminiChat {
  Future<String> generateText(String prompt) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/${UrlConstant.model}:generateContent?key=${UrlConstant.apiKey}",
    );

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
          "No response";
      return text;
    } else {
      throw Exception("Failed to generate text: ${response.body}");
    }
  }
}
