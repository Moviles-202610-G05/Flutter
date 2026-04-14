import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';

abstract class UserView {
  void onLoginSuccess();
  void mostrarUsuarios(List<Usuario> usuarios);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
  void mostrarPerfil(Usuario usuario);
}

class UserPresenter {
  final UserRepository repository = UserRepository();
  final UserView view;

  UserPresenter(this.view);

  /// Crear un nuevo usuario con unicidad de correo y username
  Future<void> crearEstudiante(Usuario usuario) async {
    try {
      bool disponible = await repository.isUsernameAvailable(usuario.username);
      if (!disponible) {
        view.mostrarError("El nombre de usuario ya está en uso.");
        return;
      }
      usuario.setRol("ESTUDIANTE");

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: usuario.email, password: usuario.password, );
      
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
      final user = await repository.signInWithGoogle();
      if (user != null) {
        view.onLoginSuccess();
      } else {
        view.mostrarError("Inicio de sesión cancelado.");
      }
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