import 'dart:io';

import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';

abstract class MenuView {
  void mostrarPlatos(List<Menu> platos);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
}

class MenuPresenter {
  final MenuRepository repository;
  final MenuView view;

  MenuPresenter(this.repository, this.view);

  
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