import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestauranteUsuarioRepository.dart';

abstract class  RestaurantUsuarioView {
  void mostrarRecomendaciones(List<Restaurant>? restaurantesSugeridos);
  void mostrarError2(String mensaje);
  void mostrarExito(String mensaje);
}

class  RestaurantUsuarioPresenter {
  final RestaurantUsuarioRepository repository;
  final  RestaurantUsuarioView view;

  RestaurantUsuarioPresenter(this.repository, this.view);

  

  Future<void> recomendaciones() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      view.mostrarRecomendaciones(await  repository.obtenerRecomendaciones(firebaseUser!.email!)); 
    } catch (e) {
      view.mostrarError2("Error al mostrar recomendaciones: $e");
    }
  }

}