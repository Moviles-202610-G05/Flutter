import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';

abstract class RestaurantView {
  void mostrarRestaurantes(List<Restaurant> restaurantes);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
}

class RestaurantPresenter {
  final RestaurantRepository repository;
  final UserRepository repositoryUsuario;
  final RestaurantView view;

  RestaurantPresenter(this.repository, this.repositoryUsuario, this.view);

  Future<void> cargarRestaurantes() async {
    try {
      final restaurantes = await repository.todosRestaurantes();
      view.mostrarRestaurantes(restaurantes);
    } catch (e) {
      view.mostrarError("Error al cargar restaurantes: $e");
    }
  }

  Future<void> agregarRestaurante(Restaurant restaurante, Usuario usuario) async {
    try {
      
      view.mostrarExito("Restaurante agregado correctamente");
      usuario.setRol("RESTAURANTE") ;
      bool disponible = await repositoryUsuario.isUsernameAvailable(usuario.username);
      if (!disponible) {
        view.mostrarError("El nombre de usuario ya está en uso.");
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: usuario.email, password: usuario.password, );

      

      await repositoryUsuario.crearUser(usuario); 
      await repository.crearRestaurante(restaurante);

      view.mostrarExito("Usuario creado correctamente."); 
    } on FirebaseAuthException catch (e) {
      view.mostrarError("Error de autenticación: ${e.message}");
    } catch (e) {
      view.mostrarError("Error al crear usuario: $e");
    }
    
  }


  
}