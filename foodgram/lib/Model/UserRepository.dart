import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/UserEntity.dart';

class UserRepository {

  Future<void> crearUser(Usuario usuario) async {
    await FirebaseFirestore.instance.collection('user').add(usuario.toMap());
  }

 
 Future<bool> isUsernameAvailable(String username) async {
  var snapshot = await FirebaseFirestore.instance
      .collection('user')
      .where('username', isEqualTo: username)
      .get();
  print (snapshot);
  return snapshot.docs.isEmpty; // true si no existe
  
}



}
