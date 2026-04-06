
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/ReviewsEntity.dart';
import 'package:foodgram/Model/ReviwsRepository.dart';

abstract class RestaurantDetaleView {
  void mostrarMenu(List<Menu>  mensaje);
  void mostrarReviews(List<Reviews>  mensaje);
  void mostrarRestaurantes(Restaurant  mensaje);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
}

class RestaurantDetalePresenter  {
  final RestaurantRepository repository;
  final MenuRepository menuRepository;
  final ReviwsRepository reviwsRepository;
  final RestaurantDetaleView view;

  RestaurantDetalePresenter(this.repository, this.menuRepository, this.reviwsRepository, this.view);

  
  Future<void> mostrarDetalle(String nombre) async {
  try {
    final reviws = await reviwsRepository.todosReviwsRestaurante(nombre);
    final menus = await menuRepository.todosMenuRestaurante(nombre);
    final restaurante = await repository.restaurante(nombre);
    print("-------------------Revisar----------------");
    print(nombre);
    print(reviws);
    view.mostrarMenu(menus);
    view.mostrarReviews(reviws);
    view.mostrarRestaurantes(restaurante);
    

  } catch (e) {
    view.mostrarError("Error al buscar restaurante: $e");
    
  }
}



  
}