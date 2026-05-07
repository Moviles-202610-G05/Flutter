import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:foodgram/BaseDeDatos/PendingDatabase.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionService.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Model/UtilitysFierbase.dart';
import 'package:rxdart/rxdart.dart';

class TrackerPresenter {

  static final ValueNotifier<bool> isAnalyzing = ValueNotifier(false);
  static final ValueNotifier<MealEntity?> analysisResult = ValueNotifier(null);
  static final BehaviorSubject<String> _userEmail = BehaviorSubject.seeded('');
  static bool _authListenerSetUp = false;

  static void setUserEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isNotEmpty && trimmed != _userEmail.value) {
      _userEmail.add(trimmed);
    }
  }

  static void _ensureAuthListener() {
    if (_authListenerSetUp) return;
    _authListenerSetUp = true;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user?.email?.isNotEmpty == true) setUserEmail(user!.email!);
    });
  }

  final NutritionService _nutritionService;
  final MealRepository _repository = MealRepository.getInstance();
  final UserRepository _userRepository = UserRepository();
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
  }) : _nutritionService = nutritionService {
    _ensureAuthListener();
  }

  static Stream<String> get userEmailStream => _userEmail.stream;

  static void forceStreamRefresh() {
    if (_userEmail.value.isNotEmpty) {
      _userEmail.add(_userEmail.value);
    }
  }

  static String get _effectiveEmail =>_userEmail.value.isNotEmpty ? _userEmail.value : 'anonimo@foodgram.com';
  late final Stream<List<MealEntity>> loggedMealsStream = _userEmail.switchMap((email) => _repository.getMealsStream(email.isNotEmpty ? email : 'anonimo@foodgram.com'));
  late final Stream<double> caloriesGoalStream =_userEmail.switchMap((email) => _userRepository.getCaloriesGoalStream(email.isNotEmpty ? email : 'anonimo@foodgram.com'));
  late final Stream<Map<String, double>> dailyStatsStream = _buildDailyStatsStream();

  Stream<Map<String, double>> _buildDailyStatsStream() {
    final todayPrefix = DateTime.now().toIso8601String().substring(0, 10);
    return _userEmail.switchMap((email) {
      final e = email.isNotEmpty ? email : 'anonimo@foodgram.com';
      return _repository.getMealsStream(e).map((meals) {
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
    });
  }

  Future<void> onImageCaptured(File image) async {
    try {
      isAnalyzing.value = true;
      onLoadingStart();
      final email = _effectiveEmail;

      // Detecta conectividad antes de intentar subir o analizar la imagen
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult == ConnectivityResult.none;

      if (isOffline) {
        // IA sin conexion — guarda como base64 en pending_meals
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        // Multithreading — encadena la insercion offline sin bloquear el hilo principal con await
        PendingDatabase.getInstance()
          .then((db) => db.insert(base64Image, DateTime.now().toIso8601String()))
          .then((_) {
            isAnalyzing.value = false;
            onOfflineSaved();
          })
          .catchError((error) {
            isAnalyzing.value = false;
            onError('Error: ${error.toString()}');
          });
        return;
      }

      //  IA con conexion  — Se sube imagen y analiza con IA con await para esperar los resultados 
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
