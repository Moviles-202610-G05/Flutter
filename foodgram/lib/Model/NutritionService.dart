import 'dart:io';
import 'package:foodgram/Model/MealEntity.dart';

// Adapter - Contrato que solo TrackerPresenter conoce
abstract class NutritionService {
  Future<MealEntity> analyzeImage(File image);
}
