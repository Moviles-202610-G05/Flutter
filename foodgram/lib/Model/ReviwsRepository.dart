import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/ReviewsEntity.dart';



class ReviwsRepository {
  Future<List<Reviews>> todosReviwsRestaurante(String nombre) async {
    final snapshot = await FirebaseFirestore.instance.collection('reviews').where('restaurant', isEqualTo: nombre).get();
    return snapshot.docs.map((doc) => Reviews.fromMap(doc.data())).toList();
  }



}

