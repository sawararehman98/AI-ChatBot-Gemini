class GeminiResponseModel {
  final String text;

  GeminiResponseModel({required this.text});

  factory GeminiResponseModel.fromJson(Map<String, dynamic> json) {
    final text = json["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "";
    return GeminiResponseModel(text: text);
  }
}
