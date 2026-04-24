import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:foodgram/BaseDeDatos/PendingMealDatabase.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionService.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Model/UtilitysFierbase.dart';

class TrackerPresenter {

  // Persiste el estado de carga entre instancias del widget.
  // Cuando el tracker monta, lee el valor actual para mostrar el spinner
  // aunque el usuario haya navegado a otra pantalla durante el análisis.
  static final ValueNotifier<bool> isAnalyzing = ValueNotifier(false);

  // Resultado del análisis — persiste para mostrarlo al volver al tracker.
  static final ValueNotifier<MealEntity?> analysisResult =
      ValueNotifier(null);

  final NutritionService _nutritionService;
  final MealRepository _repository = MealRepository.getInstance();
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Function() onLoadingStart;
  final Function(MealEntity) onSuccess;
  final Function(String) onError;
  final Function() onOfflineSaved;

  TrackerPresenter({
    required NutritionService nutritionService,
    required this.onLoadingStart,
    required this.onSuccess,
    required this.onError,
    required this.onOfflineSaved,
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
      isAnalyzing.value = true;
      onLoadingStart();
      final email = _auth.currentUser?.email ?? "anonimo@foodgram.com";

      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult == ConnectivityResult.none;

      if (isOffline) {
        final bytes       = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        final db          = await PendingMealDatabase.getInstance();
        await db.insert(base64Image, DateTime.now().toIso8601String());
        isAnalyzing.value = false;
        onOfflineSaved();
        return;
      }

      final imageUrl = await UtilitisFirebase().subirImagen(image);
      final nutritionResult = await _nutritionService.analyzeImage(image);

      final meal = MealEntity(
        dishName:      nutritionResult.dishName,
        components:    nutritionResult.components,
        totalCalories: nutritionResult.totalCalories,
        totalProteinG: nutritionResult.totalProteinG,
        totalCarbsG:   nutritionResult.totalCarbsG,
        totalFatG:     nutritionResult.totalFatG,
        confidence:    nutritionResult.confidence,
        timestamp:     DateTime.now(),
        imageUrl:      imageUrl,
      );

      await _repository.saveMeal(meal, email);

      isAnalyzing.value = false;
      analysisResult.value = meal;
      onSuccess(meal);

    } catch (e) {
      isAnalyzing.value = false;
      onError("Error: ${e.toString()}");
    }
  }
}
