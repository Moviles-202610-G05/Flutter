import 'dart:io';

import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/MenuSugestionApiAdapter.dart';
import 'package:foodgram/Model/UtilitysFierbase.dart';

abstract class MenuView {
  void mostrarPlatos(List<Menu> platos);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
  void estaCargando(bool mensaje);
}

class MenuPresenter {
  final MenuRepository repository;
  final MenuView view;
  final MenuSugestionApiAdapter menuSugestion;
  UtilitisFirebase utilitisFirebase = UtilitisFirebase();
  List<Menu> menus = [];
  

  MenuPresenter(this.repository, this.view,  this.menuSugestion);

  Future<Menu> onImageCaptured(File image) async {
    try {
      view.estaCargando(true);
      Menu prediction  = await menuSugestion.analyzeImage(image);
      
      var imagen = await utilitisFirebase.subirImagen(image);
      prediction.image = imagen; 

      view.estaCargando(false);
      return prediction ;
      

    } catch (e) {
      view.mostrarError("Error: ${e.toString()}");
      return Menu(name: "", price: "", description: "description", image: "image", restaurant: "", category: "");
    }
  }
  
  String getImage(File imagen) {
    return("");
  }
  Future<void> crearPlatos() async {
    print(menus);
    try {
      
      await repository.crearPlatos(menus);
      view.mostrarExito("Platos creados correctamente.");
    } catch (e) {
      view.mostrarError("Error al crear plato: $e");
    }
  }

  void agregarMenu(Menu menuadd){
    menus.add(menuadd);
  }


  void darMenu(){
    print(menus);
    view.mostrarPlatos(menus);
  }



}