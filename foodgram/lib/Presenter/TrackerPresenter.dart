import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionService.dart';
import 'package:foodgram/Model/UserRepository.dart';

class TrackerPresenter {

  // Adapter - Guarda el Adapter creado como un Service
  final NutritionService _nutritionService;

  // Singleton - MealRepository garantiza una sola instancia en toda la app
  final MealRepository _repository = MealRepository.getInstance();
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Function() onLoadingStart;
  final Function(MealEntity) onSuccess;
  final Function(String) onError;

  TrackerPresenter({
    required NutritionService nutritionService,
    required this.onLoadingStart,
    required this.onSuccess,
    required this.onError,
  }) : _nutritionService = nutritionService;

  Stream<List<MealEntity>> get loggedMealsStream {
    final email = _auth.currentUser?.email ?? "anonimo@foodgram.com";
    return _repository.getMealsStream(email);
  }

  Stream<Map<String, double>> get dailyStatsStream {
    final email = _auth.currentUser?.email ?? "anonimo@foodgram.com";
    final todayPrefix = DateTime.now().toIso8601String().substring(0, 10);

    return _repository.getMealsStream(email).map((meals) {
      double kcal = 0, protein = 0, carbs = 0, fat = 0;
      for (final meal in meals) {
        if (meal.timestamp.toIso8601String().startsWith(todayPrefix)) {
          kcal    += meal.totalCalories;
          protein += meal.totalProteinG;
          carbs   += meal.totalCarbsG;
          fat     += meal.totalFatG;
        }
      }
      return {'kcal': kcal, 'protein': protein, 'carbs': carbs, 'fat': fat};
    });
  }

  Stream<double> get caloriesGoalStream {
    final email = _auth.currentUser?.email ?? "anonimo@foodgram.com";
    return _userRepository.getCaloriesGoalStream(email);
  }

  Future<void> onImageCaptured(File image) async {
    try {
      onLoadingStart();
      final email = _auth.currentUser?.email ?? "anonimo@foodgram.com";

      // Adapter - Llama al contrato del Adapter para analizar la foto 
      final nutritionResult = await _nutritionService.analyzeImage(image);

      // Crea el plato para guardar usando la info que le devolvio el Adapter
      final meal = MealEntity(
        dishName:      nutritionResult.dishName,
        components:    nutritionResult.components,
        totalCalories: nutritionResult.totalCalories,
        totalProteinG: nutritionResult.totalProteinG,
        totalCarbsG:   nutritionResult.totalCarbsG,
        totalFatG:     nutritionResult.totalFatG,
        confidence:    nutritionResult.confidence,
        timestamp:     DateTime.now(),
        imagePath:     image.path,
      );

      // Guarda el plato en firebase
      await _repository.saveMeal(meal, email);
      onSuccess(meal);

    } catch (e) {
      onError("Error: ${e.toString()}");
    }
  }
}
