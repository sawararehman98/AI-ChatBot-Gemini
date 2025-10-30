import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../constant/url_constant.dart';
import '../models/gemini_response_model.dart';

class GeminiService {
  final http.Client client;

  GeminiService({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<GeminiResponseModel> generateText(String prompt) async {
    final url = Uri.parse(
      "${UrlConstant.baseUrl}/models/${UrlConstant.model}:generateContent?key=${UrlConstant.apiKey}",
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

    try {
      final response = await client
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GeminiResponseModel.fromJson(data);
      } else {
        throw _handleHttpError(response);
      }
    } on SocketException {
      throw Exception("No Internet connection.");
    } on TimeoutException {
      throw Exception(" Request timed out.");
    } on FormatException {
      throw Exception("️ Bad response format from Gemini API.");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Exception _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return Exception(" Bad request — invalid prompt or parameters.");
      case 401:
        return Exception(" Unauthorized — invalid API key.");
      case 403:
        return Exception(" Access forbidden — insufficient permissions.");
      case 429:
        return Exception(" Rate limit exceeded. Try again later.");
      case 500:
      case 503:
        return Exception(" Server error. Try again later.");
      default:
        return Exception("Unexpected error: ${response.statusCode} — ${response.body}");
    }
  }
}
