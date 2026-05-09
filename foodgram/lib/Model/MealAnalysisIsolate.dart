import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:foodgram/BaseDeDatos/PendingDatabase.dart';
import 'package:foodgram/Model/MealEntity.dart';
import 'package:foodgram/Model/NutritionApiAdapter.dart';
import 'package:foodgram/Model/NutritionApiService.dart';
import 'package:foodgram/firebase_options.dart';

Future<void> analyzePendingMeal(List<dynamic> args) async {
  final SendPort sendPort        = args[0] as SendPort;
  final RootIsolateToken token   = args[1] as RootIsolateToken;
  final Map<String, dynamic> row = Map<String, dynamic>.from(args[2] as Map);
  final String userEmail         = args[3] as String;

  try {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }

    final int id             = row['id'] as int;
    final String base64Image = row['image_base64'] as String;
    final String timestamp   = row['timestamp'] as String;
    final adapter = NutritionApiAdapter(NutritionApiService());
    late final MealEntity mealResult;
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        mealResult = await adapter.analyzeFromBase64(base64Image);
        break;
      } catch (e) {
        if (attempt == 3) rethrow;
        await Future.delayed(const Duration(seconds: 3));
      }
    }

    final docRef = await FirebaseFirestore.instance.collection('meals').add({
      'userEmail':     userEmail,
      'dishName':      mealResult.dishName,
      'totalCalories': mealResult.totalCalories,
      'totalProteinG': mealResult.totalProteinG,
      'totalCarbsG':   mealResult.totalCarbsG,
      'totalFatG':     mealResult.totalFatG,
      'confidence':    mealResult.confidence.name,
      'timestamp':     timestamp,
      'imageUrl':      null,
      'components':    mealResult.components.map((c) => {
        'food':              c.food,
        'calories':          c.calories,
        'protein_g':         c.proteinG,
        'carbs_g':           c.carbsG,
        'fat_g':             c.fatG,
        'estimated_portion': c.estimatedPortion,
      }).toList(),
    });

    final db = await PendingDatabase.getInstance();
    await db.markSynced(id);

    sendPort.send({
      'status':    'success',
      'dishName':  mealResult.dishName,
      'docId':     docRef.id,
      'base64':    base64Image,
    });
  } catch (e) {
    sendPort.send({'status': 'error', 'message': e.toString()});
  }
}
