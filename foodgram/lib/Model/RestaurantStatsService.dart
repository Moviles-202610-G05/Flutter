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
}