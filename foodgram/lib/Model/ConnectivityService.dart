import 'dart:convert';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:foodgram/BaseDeDatos/PendingMealDatabase.dart';
import 'package:foodgram/Model/MealAnalysisIsolate.dart';
import 'package:foodgram/View/Notificaciones.dart';

class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._();
  ConnectivityService._();

  static final ValueNotifier<bool> isProcessingOffline = ValueNotifier(false);

  bool _initialized = false;
  bool _wasOffline  = false;

  void initialize(String userEmail) {
    if (_initialized) return;
    _initialized = true;

    Connectivity().onConnectivityChanged.listen((result) async {
      final isOffline = result == ConnectivityResult.none;

      if (_wasOffline && !isOffline) {
        await _processPending(userEmail);
      }
      _wasOffline = isOffline;
    });
  }

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
    final db      = await PendingMealDatabase.getInstance();
    final pending = await db.getPending();
    if (pending.isEmpty) return;
    isProcessingOffline.value = true;
    int remaining = pending.length;

    for (final row in pending) {
      final receivePort = ReceivePort();
      final token       = RootIsolateToken.instance!;

      await Isolate.spawn(
        analyzePendingMeal,
        [receivePort.sendPort, token, row, userEmail],
      );

      receivePort.listen((message) async {
        receivePort.close();
        final msg = Map<String, dynamic>.from(message as Map);
        if (msg['status'] == 'success') {
          await _uploadImageAndUpdateDoc(
            docId:       msg['docId'] as String,
            base64Image: msg['base64'] as String,
          );
          await NotificationService.showMealReadyNotification(
            msg['dishName'] as String,
          );
        }
        remaining--;
        if (remaining <= 0) isProcessingOffline.value = false;
      });
    }
  }
}
