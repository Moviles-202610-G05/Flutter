import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

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

  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();

      if (account == null) return null;

      final GoogleSignInAuthentication auth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        Usuario? existe = await getUserByEmail(firebaseUser.email!);

        if (existe == null) {    
          Usuario nuevoUsuario = Usuario(
            universityId: "111111111", 
            name: firebaseUser.displayName ?? "Sin nombre",
            email: firebaseUser.email!,
            carrier: "ESTUDIANTE", 
            password: "", 
            preferences: [],
            username: firebaseUser.email!.split('@')[0],
          );
          await crearUser(nuevoUsuario);
          print("Usuario creado con éxito desde Google: ${nuevoUsuario.name}");
        }
      }
      return firebaseUser;
    } catch (e) {
      print("Error en repositorio: $e");
      return null;
    }
  }

// Obtener el documento del usuario logueado por su email
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
      await FirebaseAuth.instance.currentUser?.updatePassword(password);
    }

    if (newEmail.isNotEmpty && newEmail != currentEmail) {
      updates['email'] = newEmail;
      await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(newEmail);
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
}
