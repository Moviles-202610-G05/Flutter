import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/MealEntity.dart';

class MealRepository {

  // Crea la unica copia del objeto en memoria estatica 
  static final MealRepository _instance = MealRepository._internal(); 
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Constructor privado para evitar instanciación externa
  MealRepository._internal();

  // Factory constructor para retornar la instancia única a otros llamados 
  factory MealRepository() => _instance;

  Future<void> saveMeal(MealEntity meal, String email) async {
    await _db.collection('meals').add(meal.toMap(email));
  }

  Stream<List<MealEntity>> getMealsStream(String email) {
    return _db
        .collection('meals')
        .where('userEmail', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MealEntity.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<Map<String, dynamic>> getUserProfileStream(String email) {
    return _db
        .collection('usuarios') 
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.data();
          }
          return {}; 
        });
  }

  Stream<Map<String, double>> getDailyStatsStream(String email) {
    final now = DateTime.now();
    final todayPrefix = DateTime(now.year, now.month, now.day).toIso8601String().substring(0, 10);

    return _db.collection('meals')
        .where('userEmail', isEqualTo: email)
        // Snapshot en tiempo real del Event producer de TrackerPresenter
        .snapshots() 
        .map((snapshot) {
          double kcal = 0, protein = 0, carbs = 0, fat = 0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final String ts = data['timestamp'] ?? "";
            if (ts.startsWith(todayPrefix)) {
              kcal += (data['totalCalories'] ?? 0).toDouble();
              protein += (data['totalProteinG'] ?? 0).toDouble();
              carbs += (data['totalCarbsG'] ?? 0).toDouble();
              fat += (data['totalFatG'] ?? 0).toDouble();
            }
          }
          return {'kcal': kcal, 'protein': protein, 'carbs': carbs, 'fat': fat};
        }); 
}

}

