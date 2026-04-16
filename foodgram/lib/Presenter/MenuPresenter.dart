import 'dart:io';

import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/MenuSugestionApiAdapter.dart';
import 'package:foodgram/Model/MenuSugestionApiService.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/UtilitysFierbase.dart';

abstract class MenuView {
  void mostrarPlatos(List<Menu> platos);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
}

class MenuPresenter {
  final MenuRepository repository;
  final MenuView view;
  final MenuSugestionApiAdapter menuSugestion;
  UtilitisFirebase utilitisFirebase = UtilitisFirebase();
  

  MenuPresenter(this.repository, this.view,  this.menuSugestion);

  Future<Menu> onImageCaptured(File image) async {
    try {

      // Adapter - Llama al contrato del Adapter para analizar la foto 
      Menu prediction  = await menuSugestion.analyzeImage(image);
      var imagen = await utilitisFirebase.subirImagen(image);
      prediction.image = imagen; 

      return prediction ;
      

    } catch (e) {
      view.mostrarError("Error: ${e.toString()}");
      return Menu(name: "", price: "", description: "description", image: "image", restaurant: "", category: "");
    }
  }
  
  String getImage(File imagen) {
    return("");
  }
  Future<void> crearPlatos(List<Menu> platos) async {
    print(platos);
    try {
      
      await repository.crearPlatos(platos);
      view.mostrarExito("Platos creados correctamente.");
    } catch (e) {
      view.mostrarError("Error al crear plato: $e");
    }
  }

}