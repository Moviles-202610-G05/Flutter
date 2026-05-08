import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';

class RestaurantUsuarioRepository {
  static final RestaurantUsuarioRepository _instance = RestaurantUsuarioRepository._internal();
  
  factory RestaurantUsuarioRepository() {
    return _instance;
  }
  
  RestaurantUsuarioRepository._internal();
  final LinkedHashMap<String, List<Restaurant>> recomendacionesCache = LinkedHashMap();

  Future<List<Restaurant>?> obtenerRecomendaciones(String email) async {
  try {
    if (recomendacionesCache.containsKey(email)) {
      return recomendacionesCache[email];
    }
    final querySnapshot = await FirebaseFirestore.instance
    .collection('user_recommendations')
    .where('email', isEqualTo: email)
    .get();
    

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;        
        final List<dynamic> sugerenciasRaw = doc.data()['sugerencias'] ?? [];  
        final recomendaciones = sugerenciasRaw
          .map((item) => Restaurant.fromMap(item, id: doc.id))
          .toList();    
        recomendacionesCache[email] = recomendaciones;  
        return recomendaciones;
      } else {
        print("No hay recomendaciones para este email.");
        return []; 
      }
  } catch (e) {
    return null;
  }
}

}

