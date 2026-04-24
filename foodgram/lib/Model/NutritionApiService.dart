import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NutritionApiService {

  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _apiKey = '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';
  static const String _model  = 'nvidia/nemotron-nano-12b-v2-vl:free';
  static const String _prompt = '''
      You are a nutrition analysis AI.

      Your task is to analyze a food image and estimate its nutritional composition as accurately as possible.

      Instructions:
      1. Identify the dish name (example: "Oatmeal with berries").
      2. Identify every visible food component in the plate.
      3. Estimate the portion size of each component.
      4. Estimate calories for each component.
      5. Estimate macronutrients for each component: protein (g), carbohydrates (g), fat (g).
      6. Calculate totals for: total calories, total protein, total carbohydrates, total fat.
      7. Estimate the macronutrient distribution as percentages of total calories.

      Important rules:
      - Use realistic nutritional averages.
      - If portion size is uncertain, estimate based on a typical plate.
      - Avoid explanations outside JSON.

      Return ONLY valid JSON in this exact format:
      {
        "dish_name": "",
        "components": [
          {
            "food": "",
            "estimated_portion": "",
            "estimated_weight_g": 0,
            "calories": 0,
            "protein_g": 0,
            "carbs_g": 0,
            "fat_g": 0
          }
        ],
        "total_calories": 0,
        "macronutrients_totals": {
          "protein_g": 0,
          "carbs_g": 0,
          "fat_g": 0
        },
        "macronutrient_distribution_percent": {
          "protein": 0,
          "carbohydrates": 0,
          "fat": 0
        },
        "confidence": "low | medium | high"
      }
  ''';

  Future<Map<String, dynamic>> getRawAnalysisFromBase64(String base64Image) async {
    return _callWithBase64(base64Image);
  }

  Future<Map<String, dynamic>> getRawAnalysis(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    return _callWithBase64(base64Image);
  }

  Future<Map<String, dynamic>> _callWithBase64(String base64Image) async {
    final body = jsonEncode({
      'model': _model,
      'messages': [
        {
          'role': 'user',
          'content': [
            {'type': 'text', 'text': _prompt},
            {
              'type':      'image_url',
              'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
            },
          ],
        }
      ],
    });

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Authorization': 'Bearer $_apiKey', 'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Error de API: ${response.statusCode} — ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('API sin respuesta válida: ${response.body}');
    }
    final rawContent = choices[0]['message']['content'] as String;
    final cleanJson = _stripMarkdown(rawContent);

    return jsonDecode(cleanJson) as Map<String, dynamic>;
  }

  String _stripMarkdown(String raw) {
    return raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
  }
}
