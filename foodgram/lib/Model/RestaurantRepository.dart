import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';

import 'reviews.dart';
import 'menu.dart';

class RestaurantRepository {
  Future<List<Restaurant>> todosRestaurantes() async {
    final snapshot = await FirebaseFirestore.instance.collection('restaurants').get();
    return snapshot.docs.map((doc) => Restaurant.fromMap(doc.data())).toList();
  }

  Future<void> crearRestaurante(Restaurant restaurante) async {
    await FirebaseFirestore.instance.collection('restaurants').add(restaurante.toMap());
  }
}

