import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:foodgram/Model/MealEntity.dart';

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

  Future<MealEntity> analyzeImage(File imageFile) async {
    // Preparacion de la imagen para el envio a la API
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

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

    // Envio de la peticion a la API
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Authorization': 'Bearer $_apiKey','Content-Type':  'application/json',},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Error de API: ${response.statusCode} — ${response.body}');
    }

    // Se recive el formato de la IA
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    // Se traduce el formato de la IA en algo que se pueda procesar
    final rawContentFromIA = decoded['choices'][0]['message']['content'] as String;
    final cleanJson = _stripMarkdown(rawContentFromIA);
    final jsonMap = jsonDecode(cleanJson) as Map<String, dynamic>;

    // El adapter convierte el formato IA en formato MealEntity, no sabe nada de JSOn, solo de MealEntity
    return MealEntity.fromJson(jsonMap);
  }
  String _stripMarkdown(String raw) {
    return raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'),     '')
        .trim();
  }
}  