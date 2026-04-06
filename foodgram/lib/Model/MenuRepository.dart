import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/MenuEntity.dart';



class MenuRepository {
  Future<List<Menu>> todosMenuRestaurante(String nombre) async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').where('restaurant', isEqualTo: nombre).get();
    return snapshot.docs.map((doc) => Menu.fromMap(doc.data())).toList();
  }



}

