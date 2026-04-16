import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/UserEntity.dart';

class UserRepository {

  Future<void> crearUser(Usuario usuario) async {
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

  Future<Usuario?> getUserByEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Usuario.fromMap(snapshot.docs.first.data());
  }

  Future<void> updateProfile(
    String currentEmail, {
    required String name,
    required String username,
    required List<String> preferences,
    String newEmail = '',
    String password = '',
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: currentEmail)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return;

    final Map<String, dynamic> updates = {
      'name': name,
      'username': username,
      'preferences': preferences,
    };

    if (password.isNotEmpty) {
      updates['password'] = password;
    }

    if (newEmail.isNotEmpty && newEmail != currentEmail) {
      updates['email'] = newEmail;
    }

    await snapshot.docs.first.reference.update(updates);
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

  Stream<double> getCaloriesGoalStream(String email) {
    return FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snap) {
          if (snap.docs.isNotEmpty) {
            return (snap.docs.first.data()['caloriesGoal'] ?? 2000.0).toDouble();
          }
          return 2000.0;
        });
  }
}
