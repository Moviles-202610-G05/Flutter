import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';

abstract class MenuView {
  void mostrarPlatos(List<Menu> platos);
  void mostrarError(String mensaje);
  void mostrarExito(String mensaje);
}

class MenuPresenter {
  final MenuRepository repository;
  final MenuView view;

  MenuPresenter(this.repository, this.view);

  Future<void> crearPlatos(List<Menu> platos) async {
    try {
      
      await repository.crearPlatos(platos);
      view.mostrarExito("Platos creados correctamente.");
    } catch (e) {
      view.mostrarError("Error al crear plato: $e");
    }
  }

}