import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/MealEntity.dart';

class MealRepository {

  // Es null hasta que alguien lo crea
  static MealRepository? _instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Construtor privado para que nadie cree otras instancias
  MealRepository._();

  // Metodo de acceso global  
  static MealRepository getInstance() {
    // Solo crea una vez el MealRepository
    _instance ??= MealRepository._();
    return _instance!;
  }

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

}
