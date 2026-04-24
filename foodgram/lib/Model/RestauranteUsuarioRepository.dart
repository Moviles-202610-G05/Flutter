import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';

class RestaurantUsuarioRepository {
  Future<List<Restaurant>?> obtenerRecomendaciones(String email) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
    .collection('user_recommendations')
    .where('email', isEqualTo: email)
    .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;        
        final List<dynamic> sugerenciasRaw = doc.data()['sugerencias'] ?? [];        
        return sugerenciasRaw.map((item) => Restaurant.fromMap(item, id: doc.id)).toList();
      } else {
        print("No hay recomendaciones para este email.");
        return []; 
      }
  } catch (e) {
    return null;
  }
}

}

