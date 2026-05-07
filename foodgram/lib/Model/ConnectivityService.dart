import 'dart:convert';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:foodgram/BaseDeDatos/PendingDatabase.dart';
import 'package:foodgram/BaseDeDatos/PendingUserDataPreferences.dart';
import 'package:foodgram/Model/MealAnalysisIsolate.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Presenter/TrackerPresenter.dart';
import 'package:foodgram/View/Notificaciones.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Detecta cambios de red y sincroniza datos pendientes al reconectar
class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._();
  ConnectivityService._();

  static final ValueNotifier<bool> isProcessingOffline = ValueNotifier(false);

  bool _initialized = false;
  bool _wasOffline  = false;

  void initialize(String userEmail) {
    if (_initialized) return;
    _initialized = true;

    // Datos sin conexion — ajusta el estado inicial y sincroniza pendientes de sesiones anteriores si hay red
    Connectivity().checkConnectivity().then((result) async {
      _wasOffline = result == ConnectivityResult.none;
      if (!_wasOffline) {
        await _processPending(userEmail);
        await _processPendingProfiles();
        await _processPendingGoals();
      }
    });

    // Listener de red que procesa la cola de pendientes cuando hay internet
    Connectivity().onConnectivityChanged.listen((result) async {
      final isOffline = result == ConnectivityResult.none;

      if (_wasOffline && !isOffline) {
        await _processPending(userEmail);
        await _processPendingProfiles();
        await _processPendingGoals();
      }
      _wasOffline = isOffline;
    });
  }

  // Sube la foto a Firebase
  Future<void> _uploadImageAndUpdateDoc({
    required String docId,
    required String base64Image,
  }) async {
    try {
      final imageBytes = base64Decode(base64Image);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('meal_photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('meals')
          .doc(docId)
          .update({'imageUrl': imageUrl});
    } catch (_) {}
  }

  Future<void> _processPending(String userEmail) async {
    // IA sin conexion - Obtiene el email del usuario para saber donde guardar la comida
    String effectiveEmail = FirebaseAuth.instance.currentUser?.email?.trim() ?? '';
    if (effectiveEmail.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      effectiveEmail = prefs.getString('userEmail')?.trim() ?? userEmail.trim();
    }
    if (effectiveEmail.isEmpty) return;

    TrackerPresenter.setUserEmail(effectiveEmail);

    final db = await PendingDatabase.getInstance();
    final pending = await db.getPending();
    if (pending.isEmpty) return;
    isProcessingOffline.value = true;
    int remaining = pending.length;

    for (final row in pending) {
      // IA sin conexion - Crea un puerto para recibir el resultado del Isolate
      final receivePort = ReceivePort();
      final token = RootIsolateToken.instance!;

      // IA sin conexion - Se crea el Isolate para procesar cada comida pendiente sin bloquear el hilo principal
      await Isolate.spawn(analyzePendingMeal, [receivePort.sendPort, token, row, effectiveEmail],);

      receivePort.listen((message) async {
        receivePort.close();
        final msg = Map<String, dynamic>.from(message as Map);
        if (msg['status'] == 'success') {
          await _uploadImageAndUpdateDoc(
            docId: msg['docId'] as String,
            base64Image: msg['base64'] as String,
          );
          // IA sin conexion - Marca como sincronizado en SQLite 
          await db.markSynced(row['id'] as int);
          await NotificationService.showMealReadyNotification(msg['dishName'] as String,);
        }
        remaining--;
        if (remaining <= 0) {
          isProcessingOffline.value = false;
          TrackerPresenter.forceStreamRefresh();
        }
      });
    }
  }

  // Datos sin conexion — sincroniza el perfil guardado en SharedPreferences con Firebase al reconectar
  Future<void> _processPendingProfiles() async {
    final prefs = PendingUserDataPreferences();
    final json = await prefs.getPendingProfile();
    if (json == null) return;

    try {
      final data = Map<String, dynamic>.from(jsonDecode(json) as Map);
      final repo = UserRepository();
      await repo.updateProfile(
        data['currentEmail'] as String,
        name: data['name'] as String,
        username: data['username'] as String,
        preferences: List<String>.from(data['preferences'] as List),
        newEmail: (data['newEmail'] as String?) ?? '',
      );
      await prefs.clearPendingProfile();
    } catch (_) {}
  }

  // Datos sin conexion — sincroniza las metas nutricionales guardadas en SharedPreferences con Firebase al reconectar
  Future<void> _processPendingGoals() async {
    final prefs = PendingUserDataPreferences();
    final json = await prefs.getPendingGoals();
    if (json == null) return;

    try {
      final data = Map<String, dynamic>.from(jsonDecode(json) as Map);
      final repo = UserRepository();
      await repo.updateNutritionGoals(
        data['email'] as String,
        calories: (data['calories'] as num).toDouble(),
        protein:  (data['proteins'] as num).toDouble(),
        carbs:    (data['carbs'] as num).toDouble(),
        fat:      (data['fats'] as num).toDouble(),
      );
      await prefs.clearPendingGoals();
    } catch (_) {}
  }
}
