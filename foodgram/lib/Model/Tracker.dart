class NutritionComponent {
  final String food;
  final String estimatedPortion;
  final int estimatedWeightG;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const NutritionComponent({
    required this.food,
    required this.estimatedPortion,
    required this.estimatedWeightG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  factory NutritionComponent.fromJson(Map<String, dynamic> json) {
    return NutritionComponent(
      food:               json['food']               as String,
      estimatedPortion:   json['estimated_portion']  as String,
      estimatedWeightG:   (json['estimated_weight_g'] as num).toInt(),
      calories:           (json['calories']           as num).toInt(),
      proteinG:           (json['protein_g']          as num).toDouble(),
      carbsG:             (json['carbs_g']            as num).toDouble(),
      fatG:               (json['fat_g']              as num).toDouble(),
    );
  }
}

enum ConfidenceLevel { low, medium, high }

ConfidenceLevel _parseConfidence(String raw) {
  switch (raw.toLowerCase().trim()) {
    case 'high':   return ConfidenceLevel.high;
    case 'medium': return ConfidenceLevel.medium;
    default:       return ConfidenceLevel.low;
  }
}

// ─────────────────────────────────────────────────────────────
// Resultado completo que devuelve la API
// Es exactamente el JSON que ya produce tu script Python
// ─────────────────────────────────────────────────────────────
class NutritionResult {
  final String dishName;
  final List<NutritionComponent> components;

  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;

  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;

  final ConfidenceLevel confidence;

  const NutritionResult({
    required this.dishName,
    required this.components,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
    required this.confidence,
  });

  factory NutritionResult.fromJson(Map<String, dynamic> json) {
    final totals = json['macronutrients_totals']            as Map<String, dynamic>;
    final dist   = json['macronutrient_distribution_percent'] as Map<String, dynamic>;

    return NutritionResult(
      dishName:       json['dish_name'] as String,
      components:     (json['components'] as List)
                          .map((e) => NutritionComponent.fromJson(e as Map<String, dynamic>))
                          .toList(),
      totalCalories:  (json['total_calories'] as num).toInt(),
      totalProteinG:  (totals['protein_g']    as num).toDouble(),
      totalCarbsG:    (totals['carbs_g']      as num).toDouble(),
      totalFatG:      (totals['fat_g']        as num).toDouble(),
      proteinPercent: (dist['protein']        as num).toDouble(),
      carbsPercent:   (dist['carbohydrates']  as num).toDouble(),
      fatPercent:     (dist['fat']            as num).toDouble(),
      confidence:     _parseConfidence(json['confidence'] as String),
    );
  }

  // Útil para debug
  @override
  String toString() =>
      'NutritionResult(dish: $dishName, kcal: $totalCalories, '
      'P: ${totalProteinG}g, C: ${totalCarbsG}g, F: ${totalFatG}g, '
      'confidence: ${confidence.name})';
}