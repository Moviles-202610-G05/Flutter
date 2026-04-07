import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart' show StreamZip;

class TrackerPresenter {

  final NutritionApiService _api = NutritionApiService();
  final MealRepository _repository = MealRepository();  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Function() onLoadingStart;
  final Function(MealEntity) onSuccess;
  final Function(String) onError;

  TrackerPresenter({
    required this.onLoadingStart,
    required this.onSuccess,
    required this.onError,
  });

  Stream<List<MealEntity>> get loggedMealsStream {
    final email = FirebaseAuth.instance.currentUser?.email ?? "anonimo@foodgram.com";
    return _repository.getMealsStream(email);
  }

  // Event producer, se emite un evento cada vez que los datos de las estadisticas cambian
  Stream<Map<String, double>> get dailyStatsStream {
    final email = FirebaseAuth.instance.currentUser?.email ?? "anonimo@foodgram.com";
    return _repository.getDailyStatsStream(email);
  }

  Stream<double> get caloriesGoalStream {
    final email = _auth.currentUser?.email ?? "anonimo@foodgram.com";
    
    return _firestore
        .collection('user').where('email', isEqualTo: email)
        .snapshots()
        .map((snap) {
          if (snap.docs.isNotEmpty) {
            return (snap.docs.first.data()['caloriesGoal'] ?? 2000.0).toDouble();
          }
          return 2000.0; });
  }

  Stream<Map<String, double>> get nutritionGoalsStream {
    final email = _auth.currentUser?.email ?? "";
    return _repository.getUserProfileStream(email).map((data) {
      return {
        'caloriesGoal': (data['caloriesGoal'] ?? 2000.0).toDouble(),
        'proteinGoal': (data['proteinGoal'] ?? 100.0).toDouble(),
        'carbsGoal': (data['carbsGoal'] ?? 200.0).toDouble(),
        'fatGoal': (data['fatGoal'] ?? 60.0).toDouble(),
      };
    });
  }

  Stream<Map<String, double>> get macroProgressStream {
    final email = _auth.currentUser?.email ?? "";
    return StreamZip([dailyStatsStream, nutritionGoalsStream]).map((List<Map<String, double>> results) {
      final stats = results[0];
      final goals = results[1];

      double calc(double consumed, double goal, double fallback) {
        if (goal <= 0) return (consumed / fallback).clamp(0.0, 1.0);
        return (consumed / goal).clamp(0.0, 1.0);
      }

      return {
        'kcalProgress': (stats['kcal']! / (goals['caloriesGoal']! > 0 ? goals['caloriesGoal']! : 2000.0)).clamp(0.0, 1.0),
        'proteinProgress': (stats['protein']! / (goals['proteinGoal']! > 0 ? goals['proteinGoal']! : 100.0)).clamp(0.0, 1.0),
        'carbsProgress': (stats['carbs']! / (goals['carbsGoal']! > 0 ? goals['carbsGoal']! : 200.0)).clamp(0.0, 1.0),
        'fatProgress': (stats['fat']! / (goals['fatGoal']! > 0 ? goals['fatGoal']! : 60.0)).clamp(0.0, 1.0),
        'totalCaloriesGoal': goals['caloriesGoal']!,
      };
    });
  }

  Future<void> onImageCaptured(File image) async {
    try {
      // Uso de CallBacks, el Presenter notifica que el proceso de analisis comenzo
      onLoadingStart();

      final email = FirebaseAuth.instance.currentUser?.email ?? "anonimo@foodgram.com";
      final nutritionResult = await _api.analyzeImage(image);
      
      final meal = MealEntity(
        dishName: nutritionResult.dishName,
        components: nutritionResult.components,
        totalCalories: nutritionResult.totalCalories,
        totalProteinG: nutritionResult.totalProteinG,
        totalCarbsG: nutritionResult.totalCarbsG,
        totalFatG: nutritionResult.totalFatG,
        confidence: nutritionResult.confidence, 
        timestamp: DateTime.now(),      
        imagePath: image.path,        
      );

      await _repository.saveMeal(meal, email);

      // Uso de CallBacks, el Presenter notifica a la vista que el dato está listo.
      onSuccess(meal);

    } catch (e) {
      // Uso de CallBacks, el Presenter notifica a la vista que el dato está listo.
      onError("Error: ${e.toString()}");
    }
  }
}