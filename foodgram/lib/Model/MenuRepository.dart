import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/UtilitysFierbase.dart';



class MenuRepository {
  UtilitisFirebase utilitisFirebase =UtilitisFirebase() ; 
  Future<List<Menu>> todosMenuRestaurante(String nombre) async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').where('restaurant', isEqualTo: nombre).get();
    return snapshot.docs.map((doc) => Menu.fromMap(doc.data())).toList();
  }

  Future<void> crearPlatos(List<Menu> platos) async {
  final collection = FirebaseFirestore.instance.collection('menu');

  for (final plato in platos) {

    await collection.add(plato.toMap());
  }
}
}

