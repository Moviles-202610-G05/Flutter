import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MenuSugestionApiService {

  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _apiKey = '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';
  static const String _model  = 'nvidia/nemotron-nano-12b-v2-vl:free';
  static const String _prompt = '''
      You are a nutrition analysis AI.

      Your task is to analyze a food image and predict diferent information of the dish.

      Instructions:
      1. Identify the dish name (example: "Oatmeal with berries"), no more than 8 words.
      2. Identify every visible food component in the plate.
      3. Estimate a specific price in US dolars.
      4. Give a small description of the dish no more than 50 words.
      5. Select on of the folowing categoris for the dish: Main Course, Appetizer, Dessert, Beverage, Soup, Salad.

      Important rules:
      - Use realistic information.
      - The price do not need to have the \$ simboll
      - Avoid explanations outside JSON.

      Return ONLY valid JSON in this exact format:
      {
        "name": "",
        "price": "",
        "description": "",
        "category": ""
      }
  ''';

  Future<Map<String, dynamic>> getRawAnalysis(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    print("LLLLLEGAAAAAAAAAA");

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
    print("LLLLLEGAAAAAAAAAA2");
    if (response.statusCode != 200) {
      throw Exception('Error de API: ${response.statusCode} — ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    // Limpia losbloques markdown
    final rawContent = decoded['choices'][0]['message']['content'] as String;
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
