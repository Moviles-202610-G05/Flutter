import 'dart:io';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionService.dart';
import 'package:foodgram/Model/NutritionApiService.dart';

class NutritionApiAdapter implements NutritionService {

  final NutritionApiService _service;
  NutritionApiAdapter(this._service);

  @override
  Future<MealEntity> analyzeImage(File image) async {
    final aiJson = await _service.getRawAnalysis(image);
    return _adapt(aiJson);
  }

  Future<MealEntity> analyzeFromBase64(String base64Image) async {
    final aiJson = await _service.getRawAnalysisFromBase64(base64Image);
    return _adapt(aiJson);
  }

  MealEntity _adapt(Map<String, dynamic> aiJson) {
    final macros = aiJson['macronutrients_totals'] as Map<String, dynamic>?;
    return MealEntity(
      dishName:      (aiJson['dish_name'] ?? '') as String,
      components:    (aiJson['components'] as List? ?? [])
          .map((e) => NutritionComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      // .toInt() en lugar de "as int" para manejar tanto int como double del JSON
      totalCalories: (aiJson['total_calories'] ?? 0).toInt(),
      totalProteinG: (macros?['protein_g'] ?? 0).toDouble(),
      totalCarbsG:   (macros?['carbs_g'] ?? 0).toDouble(),
      totalFatG:     (macros?['fat_g'] ?? 0).toDouble(),
      confidence:    _parseConfidence((aiJson['confidence'] ?? 'low') as String),
      timestamp:     DateTime.now(),
    );
  }

  static ConfidenceLevel _parseConfidence(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'high':   return ConfidenceLevel.high;
      case 'medium': return ConfidenceLevel.medium;
      default:       return ConfidenceLevel.low;
    }
  }
}
