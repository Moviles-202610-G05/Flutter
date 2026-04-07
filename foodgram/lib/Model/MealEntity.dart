enum ConfidenceLevel { low, medium, high }

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
      food: (json['food'] ?? 'Unknown') as String,
      estimatedPortion: (json['estimated_portion'] ?? '') as String,
      estimatedWeightG: (json['estimated_weight_g'] ?? 0).toInt(),
      calories: (json['calories'] ?? 0).toInt(),
      proteinG: (json['protein_g'] ?? 0).toDouble(),
      carbsG: (json['carbs_g'] ?? 0).toDouble(),
      fatG: (json['fat_g'] ?? 0).toDouble(),
    );
  }
}

class MealEntity {
  final String dishName;
  final List<NutritionComponent> components;
  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final ConfidenceLevel confidence;
  final DateTime timestamp; 
  final String? imagePath;

  const MealEntity({
    required this.dishName,
    required this.components,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.confidence,
    required this.timestamp,
    this.imagePath,
  });

  factory MealEntity.fromJson(Map<String, dynamic> json) {
    final macros = json['macronutrients_totals'] as Map<String, dynamic>?;

    return MealEntity(
      dishName: (json['dishName'] ?? json['dish_name'] ?? '') as String,
      components: (json['components'] as List? ?? [])
          .map((e) => NutritionComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['totalCalories'] ?? json['total_calories'] ?? 0) as int,
      totalProteinG: (json['totalProteinG'] ?? macros?['protein_g'] ?? 0).toDouble(),
      totalCarbsG:   (json['totalCarbsG']   ?? macros?['carbs_g']   ?? 0).toDouble(),
      totalFatG:     (json['totalFatG']     ?? macros?['fat_g']     ?? 0).toDouble(),
      confidence: _parseConfidence((json['confidence'] ?? 'low') as String),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toMap(String email) {
    return {
      'userEmail': email,
      'dishName': dishName,
      'totalCalories': totalCalories,
      'totalProteinG': totalProteinG,
      'totalCarbsG': totalCarbsG,
      'totalFatG': totalFatG,
      'confidence': confidence.name,
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
      'components': components.map((c) => {
        'food': c.food,
        'calories': c.calories,
        'protein_g': c.proteinG, 
        'carbs_g': c.carbsG,     
        'fat_g': c.fatG,         
        'estimated_portion': c.estimatedPortion
      }).toList(),
    };
  }

  static ConfidenceLevel _parseConfidence(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'high': return ConfidenceLevel.high;
      case 'medium': return ConfidenceLevel.medium;
      default: return ConfidenceLevel.low;
    }
  }

}