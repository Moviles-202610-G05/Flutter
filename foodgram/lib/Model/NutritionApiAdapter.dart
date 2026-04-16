import 'dart:io';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionService.dart';
import 'package:foodgram/Model/NutritionApiService.dart';

// Adapter - Finje ser Services pero en realidad es Adapter
class NutritionApiAdapter implements NutritionService {

  final NutritionApiService _service;
  NutritionApiAdapter(this._service);

  @override
  // Extiende el contrato del Services para traducir
  Future<MealEntity> analyzeImage(File image) async {
    // Pide el JSON de la API
    final aiJson = await _service.getRawAnalysis(image);
    // Traduce eso a un MealEntity
    return _adapt(aiJson);
  }

  // Adapta la info y devuelve un MealEntity
  MealEntity _adapt(Map<String, dynamic> aiJson) {
    final macros = aiJson['macronutrients_totals'] as Map<String, dynamic>?;
    return MealEntity(
      dishName: (aiJson['dish_name'] ?? '') as String,
      components: (aiJson['components'] as List? ?? [])
          .map((e) => NutritionComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (aiJson['total_calories'] ?? 0) as int,
      totalProteinG: (macros?['protein_g'] ?? 0).toDouble(),
      totalCarbsG: (macros?['carbs_g'] ?? 0).toDouble(),
      totalFatG: (macros?['fat_g'] ?? 0).toDouble(),
      confidence: _parseConfidence((aiJson['confidence'] ?? 'low') as String),
      timestamp: DateTime.now(),
    );
  }

  // Nivel de confidencia de la imagen 
  static ConfidenceLevel _parseConfidence(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'high':   return ConfidenceLevel.high;
      case 'medium': return ConfidenceLevel.medium;
      default:       return ConfidenceLevel.low;
    }
  }
}
