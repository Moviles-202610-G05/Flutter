import 'dart:io';
import 'package:foodgram/Model/MealEntity.dart';

abstract class NutritionService {
  Future<MealEntity> analyzeImage(File image);
}
