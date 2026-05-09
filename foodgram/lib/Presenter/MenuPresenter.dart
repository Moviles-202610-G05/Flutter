import 'dart:io';

import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/MenuSugestionApiAdapter.dart';
import 'package:foodgram/Model/MenuSugestionApiService.dart';
import 'package:foodgram/Model/UsuarioEntity.dart';
import 'package:foodgram/Model/UtilitysFierbase.dart';
import 'package:hive/hive.dart';

abstract class MenuView {
  void mostrarPlatos(List<Menu> platos);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
  void estaCargando(bool mensaje);
}

class MenuPresenter {
  final MenuRepository repository = MenuRepository();
  final MenuView view;
  final MenuSugestionApiAdapter menuSugestion = MenuSugestionApiAdapter(MenuSugestionApiService());
  UtilitisFirebase utilitisFirebase = UtilitisFirebase();
  List<Menu> menus = [];
  

  MenuPresenter(this.view);

  Future<Menu> onImageCaptured(File image) async {
    try {
      Menu prediction  = await menuSugestion.analyzeImage(image);
      
      var imagen = await utilitisFirebase.subirImagen(image);
      prediction.image = imagen; 

      view.estaCargando(false);
      return prediction ;
      

    } catch (e) {
      view.mostrarError("Error: ${e.toString()}");
      return Menu(name: "", price: "", description: "description", image: "image", restaurant: "", category: "Main Course");
    }
  }
  
  String getImage(File imagen) {
    return("");
  }
  Future<void> crearPlatos() async {
    try {
      
      await repository.crearPlatos(menus);
      view.mostrarExito("Platos creados correctamente.");
    } catch (e) {
      view.mostrarError("Error al crear plato: $e");
    }
  }


  static Future<void> registrarOffline( List<Menu> menus, String nombreRestaurante) async {
    for (final menu in menus) {
      menu.image = menu.imagenFiel?.path ?? "";
      menu.restaurant = nombreRestaurante;
      Box<Menu> box = Hive.box<Menu>('menu');
      await box.put(menu.name, menu);
      print("Usuario guardado offline con pendingSync");
      }
  }

  Future<void> registerPending()async{
    final box = Hive.box<Menu>('menu');
    menus = box.values.where((u) => u.pendingSync).toList();
    crearPlatos();
    await box.clear();
    
  }

  void agregarMenu(Menu menuadd){
    
    menus.add(menuadd);
  }


  void darMenu(){
    print(menus);
    view.mostrarPlatos(menus);
  }



}