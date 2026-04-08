import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';


class RestaurantUsuarioRepository {
  Future<List<Restaurant>?> obtenerRecomendaciones(String email) async {
  try {
    print("-----------------hola2---------------");
    // 1. Obtenemos la referencia al documento
    final querySnapshot = await FirebaseFirestore.instance
    .collection('user_recommendations')
    .where('email', isEqualTo: email)
    .get();

// 2. Verificamos si encontramos al menos un documento
      if (querySnapshot.docs.isNotEmpty) {
        // Tomamos el primer documento encontrado
        final doc = querySnapshot.docs.first;
        
        // Extraemos la lista de sugerencias del JSON
        final List<dynamic> sugerenciasRaw = doc.data()['sugerencias'] ?? [];
        
        // Convertimos cada mapa en un objeto Restaurant
        return sugerenciasRaw.map((item) => Restaurant.fromMap(item)).toList();
      } else {
        print("No hay recomendaciones para este email.");
        return []; // O tus restaurantes por defecto
      }
  } catch (e) {
    print("----------------Error al obtener recomendaciones: $e-------------------");
    return null;
  }
}

}

