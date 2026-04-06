import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';

abstract class RestaurantView {
  void mostrarRestaurantes(List<Restaurant> restaurantes);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
}

class RestaurantPresenter {
  final RestaurantRepository repository;
  final RestaurantView view;

  RestaurantPresenter(this.repository, this.view);

  Future<void> cargarRestaurantes() async {
    try {
      final restaurantes = await repository.todosRestaurantes();
      view.mostrarRestaurantes(restaurantes);
    } catch (e) {
      view.mostrarError("Error al cargar restaurantes: $e");
    }
  }

  Future<void> agregarRestaurante(Restaurant restaurante) async {
    try {
      await repository.crearRestaurante(restaurante);
      view.mostrarExito("Restaurante agregado correctamente");
      cargarRestaurantes(); // refresca la lista
    } catch (e) {
      view.mostrarError("Error al agregar restaurante: $e");
    }
  }
  
}