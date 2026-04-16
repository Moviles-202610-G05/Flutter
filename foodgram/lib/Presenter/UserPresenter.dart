import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class UserView {
  void onLoginSuccess();
  void mostrarUsuarios(List<Usuario> usuarios);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
  void mostrarPerfil(Usuario usuario);
}

class UserPresenter {
  final UserRepository repository = UserRepository();
  final MealRepository _mealRepository = MealRepository.getInstance();
  final UserView view;

  UserPresenter(this.view);

  Stream<Map<String, double>> get dailyStatsStream {
    final email = FirebaseAuth.instance.currentUser?.email ?? "anonimo@foodgram.com";
    final todayPrefix = DateTime.now().toIso8601String().substring(0, 10);

    return _mealRepository.getMealsStream(email).map((meals) {
      double kcal = 0, protein = 0, carbs = 0, fat = 0;
      for (final meal in meals) {
        if (meal.timestamp.toIso8601String().startsWith(todayPrefix)) {
          kcal    += meal.totalCalories;
          protein += meal.totalProteinG;
          carbs   += meal.totalCarbsG;
          fat     += meal.totalFatG;
        }
      }
      return {'kcal': kcal, 'protein': protein, 'carbs': carbs, 'fat': fat};
    });
  }

  Future<void> crearEstudiante(Usuario usuario) async {
    try {
      bool disponible = await repository.isUsernameAvailable(usuario.username);
      if (!disponible) {
        view.mostrarError("El nombre de usuario ya está en uso.");
        return;
      }
      usuario.setRol("ESTUDIANTE");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: usuario.email, password: usuario.password);
      await repository.crearUser(usuario);
      view.mostrarExito("Usuario creado correctamente.");

    } on FirebaseAuthException catch (e) {
      view.mostrarError("Error de autenticación: ${e.message}");
    } catch (e) {
      view.mostrarError("Error al crear usuario: $e");
    }
  }

  Future<void> cargarPerfilActual() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        view.mostrarError("No hay sesión activa.");
        return;
      }
      final usuario = await repository.getUserByEmail(firebaseUser.email!);
      if (usuario == null) {
        view.mostrarError("No se encontró el perfil del usuario.");
        return;
      }
      view.mostrarPerfil(usuario);
    } catch (e) {
      view.mostrarError("Error al cargar perfil: $e");
    }
  }

  Future<void> iniciarSesionGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final GoogleSignInAccount account = await googleSignIn.authenticate();
      final GoogleSignInAuthentication auth = account.authentication;
      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        view.mostrarError("Error en autenticación.");
        return;
      }

      // Si es primera vez, crear el usuario en firebase
      final existe = await repository.getUserByEmail(firebaseUser.email!);
      if (existe == null) {
        await repository.crearUser(Usuario(
          universityId: "111111111",
          name: firebaseUser.displayName ?? "Sin nombre",
          email: firebaseUser.email!,
          carrier: "ESTUDIANTE",
          password: "",
          preferences: [],
          username: firebaseUser.email!.split('@')[0],
        ));
      }

      view.onLoginSuccess();
    } on FirebaseAuthException catch (e) {
      view.mostrarError("Error de autenticación: ${e.message}");
    } catch (e) {
      view.mostrarError("Error de autenticación: $e");
    }
  }

  Future<void> actualizarPerfil({
    required String currentEmail,
    required String name,
    required String username,
    required List<String> preferences,
    String newEmail = '',
    String password = '',
  }) async {
    try {
      if (password.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updatePassword(password);
      }
      if (newEmail.isNotEmpty && newEmail != currentEmail) {
        await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(newEmail);
      }

      await repository.updateProfile(
        currentEmail,
        name: name,
        username: username,
        preferences: preferences,
        newEmail: newEmail,
        password: password,
      );
      view.mostrarExito("Profile updated successfully.");
    } on FirebaseAuthException catch (e) {
      view.mostrarError("Auth error: ${e.message}");
    } catch (e) {
      view.mostrarError("Error updating profile: $e");
    }
  }

  Future<void> guardarNutritionGoals({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return;

      await repository.updateNutritionGoals(
        firebaseUser.email!,
        calories: calories,
        protein:  protein,
        carbs:    carbs,
        fat:      fat,
      );
      view.mostrarExito("Goals guardados.");
    } catch (e) {
      view.mostrarError("Error al guardar goals: $e");
    }
  }

}
