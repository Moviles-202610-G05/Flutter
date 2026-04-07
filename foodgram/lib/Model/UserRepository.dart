import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/UserEntity.dart';

class UserRepository {

  Future<void> crearUser(Ususario usuario) async {
    await FirebaseFirestore.instance.collection('user').add(usuario.toMap());
  }

  Future<bool> isUsernameAvailable(String username) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get();
    print (snapshot);
    return snapshot.docs.isEmpty; 
  }

// Obtener el documento del usuario logueado por su email
  Future<Ususario?> getUserByEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Ususario.fromMap(snapshot.docs.first.data());
  }

  Future<void> updateNutritionGoals(String email, {
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return;

    await snapshot.docs.first.reference.update({
      'caloriesGoal': calories,
      'proteinGoal':  protein,
      'carbsGoal':    carbs,
      'fatGoal':      fat,
    });
  }
}
