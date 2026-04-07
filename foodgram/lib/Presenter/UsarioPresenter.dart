import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';

abstract class UserView {
  void mostrarUsuarios(List<Usuario> usuarios);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
  void mostrarPerfil(Ususario usuario);
}

class UserPresenter {
  final UserRepository repository;
  final UserView view;

  UserPresenter(this.repository, this.view);


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

   // Carga el perfil del usuario actualmente logueado
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