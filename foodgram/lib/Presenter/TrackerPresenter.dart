import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> onImageCaptured(File image) async {
    try {
      // Uso de CallBacks, el Presenter notifica que el proceso de analisis comenzo
      onLoadingStart();

      final email = FirebaseAuth.instance.currentUser?.email ?? "anonimo@foodgram.com";

      // Presenter, le manda la foto a la API para analizar la imagen 
      final nutritionResult = await _api.analyzeImage(image);
      
      // Crea el plato para guardar usando MealEntity 
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