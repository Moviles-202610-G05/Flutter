import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/BaseDeDatos/PendingMealDatabase.dart';
import 'package:foodgram/Model/MealRepository.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Presenter/TrackerPresenter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final todayPrefix = DateTime.now().toIso8601String().substring(0, 10);
    return TrackerPresenter.userEmailStream.switchMap((email) {
      final e = email.isNotEmpty ? email : 'anonimo@foodgram.com';
      return _mealRepository.getMealsStream(e).map((meals) {
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

  // Login sin conexion — guarda el perfil en SharedPreferences al hacer login online
  Future<void> cacheProfileSilently() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return;
      final usuario = await repository.getUserByEmail(firebaseUser.email!);
      if (usuario == null) return;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfileJson', jsonEncode(usuario.toMap()));
    } catch (_) {}
  }

  Future<void> cargarPerfilActual() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity == ConnectivityResult.none) {
        // Login sin conexion — carga perfil desde SharedPreferences 
        final prefs = await SharedPreferences.getInstance();
        final cachedJson = prefs.getString('userProfileJson');
        if (cachedJson != null) {
          final data = jsonDecode(cachedJson) as Map<String, dynamic>;
          view.mostrarPerfil(Usuario.fromMap(data));
        } else {
          view.mostrarError("No internet connection. Profile data not available offline.");
        }
        return;
      }

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        final prefs = await SharedPreferences.getInstance();
        final cachedJson = prefs.getString('userProfileJson');
        if (cachedJson != null) {
          final data = jsonDecode(cachedJson) as Map<String, dynamic>;
          view.mostrarPerfil(Usuario.fromMap(data));
        } else {
          view.mostrarError("No hay sesión activa.");
        }
        return;
      }
      final usuario = await repository.getUserByEmail(firebaseUser.email!);
      if (usuario == null) {
        view.mostrarError("No se encontró el perfil del usuario.");
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfileJson', jsonEncode(usuario.toMap()));

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

      await cacheProfileSilently();
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
    void Function()? onOfflineSaved,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Datos sin conexion — serializa el perfil como JSON y lo guarda en pending_profile_updates
      final db = await PendingMealDatabase.getInstance();
      final payload = jsonEncode({
        'currentEmail': currentEmail,
        'name': name,
        'username': username,
        'preferences': preferences,
        'newEmail': newEmail,
      });

      await db.insertPendingProfile(payload, DateTime.now().toIso8601String());

      // Se actualiza el perfil en SharedPreferences para reflejar los cambios o
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('userProfileJson');
      if (cachedJson != null) {
        final data = jsonDecode(cachedJson) as Map<String, dynamic>;
        data['name'] = name;
        data['username'] = username;
        data['preferences'] = preferences;
        if (newEmail.isNotEmpty) data['email'] = newEmail;
        await prefs.setString('userProfileJson', jsonEncode(data));
      }

      onOfflineSaved?.call();
      return;
    }
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
