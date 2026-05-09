import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantStatsService {
  static final _db = FirebaseFirestore.instance;

  /// Llama esto cuando el usuario toca el primer restaurante
  static Future<void> registerFirstPositionClick(String name , String id) async {
    final docRef = _db.collection('restaurant_stats').doc(id);

    await docRef.set({
      'restaurant_ID': id,
      'restaurantName': name,
      'firstPositionClicks': FieldValue.increment(1),
      'clicks': FieldValue.increment(1),
    }, SetOptions(merge: true)); // merge:true para no sobreescribir otros campos
  }
  static Future<void> registerClick(String name , String id) async {
    final docRef = _db.collection('restaurant_stats').doc(id);

    await docRef.set({
      'restaurant_ID': id,
      'restaurantName': name,
      'firstPositionClicks': FieldValue.increment(0),
      'clicks': FieldValue.increment(1),
    }, SetOptions(merge: true)); // merge:true para no sobreescribir otros campos
  }

  // Analytics — registra cada tap como evento con timestamp para analisis temporal
  static Future<void> registerInteraction(String restaurantId, String restaurantName,
      String userId, bool isFirstPosition) async {
    await _db.collection('restaurant_interactions').add({
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': userId,
      'isFirstPosition': isFirstPosition,
    });
  }

}