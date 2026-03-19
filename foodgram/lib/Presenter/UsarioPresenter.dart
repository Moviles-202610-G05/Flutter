import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';


/// La vista define qué debe mostrar la UI
abstract class UserView {
  void mostrarUsuarios(List<Usuario> usuarios);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
}

/// El presenter conecta la vista con el repositorio
class UserPresenter {
  final UserRepository repository;
  final UserView view;

  UserPresenter(this.repository, this.view);


  /// Crear un nuevo usuario con unicidad de correo y username
  Future<void> crearEstudiante(Usuario usuario) async {
    try {
      // 1. Validar unicidad de username
      bool disponible = await repository.isUsernameAvailable(usuario.username);
      if (!disponible) {
        view.mostrarError("El nombre de usuario ya está en uso.");
        return;
      }
      usuario.setRol("ESTUDIANTE");

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: usuario.email, password: usuario.password, );

      

      // 3. Guardar datos adicionales en Firestore
      await repository.crearUser(usuario); 

      view.mostrarExito("Usuario creado correctamente."); 
    } on FirebaseAuthException catch (e) {
      view.mostrarError("Error de autenticación: ${e.message}");
    } catch (e) {
      view.mostrarError("Error al crear usuario: $e");
    }
  }
}