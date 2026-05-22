import 'package:cloud_firestore/cloud_firestore.dart';

// Almacena en Firestore solo referencias ligeras (nombres), no datos redundantes.
// La colección 'saved_items' reemplaza las antiguas 'saved_restaurants' y 'saved_meals'.
class SavedRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveRestaurant(String userEmail, String restaurantName) async {
    await _db.collection('saved_items').add({
      'userEmail': userEmail,
      'restaurantName': restaurantName,
      'dishName': '',
      'type': 'restaurant',
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unsaveRestaurant(
      String userEmail, String restaurantName) async {
    final snap = await _db
        .collection('saved_items')
        .where('userEmail', isEqualTo: userEmail)
        .where('restaurantName', isEqualTo: restaurantName)
        .where('type', isEqualTo: 'restaurant')
        .get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> saveDish(
      String userEmail, String restaurantName, String dishName) async {
    await _db.collection('saved_items').add({
      'userEmail': userEmail,
      'restaurantName': restaurantName,
      'dishName': dishName,
      'type': 'dish',
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unsaveDish(
      String userEmail, String restaurantName, String dishName) async {
    final snap = await _db
        .collection('saved_items')
        .where('userEmail', isEqualTo: userEmail)
        .where('restaurantName', isEqualTo: restaurantName)
        .where('dishName', isEqualTo: dishName)
        .where('type', isEqualTo: 'dish')
        .get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  // Devuelve [{restaurantName, dishName, type}] para todos los ítems del usuario
  Future<List<Map<String, dynamic>>> getSavedRefs(String userEmail) async {
    final snap = await _db
        .collection('saved_items')
        .where('userEmail', isEqualTo: userEmail)
        .get();
    return snap.docs.map((doc) {
      final data = doc.data();
      return {
        'restaurantName': data['restaurantName'] as String,
        'dishName': data['dishName'] as String,
        'type': data['type'] as String,
      };
    }).toList();
  }
}
