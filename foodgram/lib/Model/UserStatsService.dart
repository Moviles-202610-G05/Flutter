import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/UsuarioEntity.dart';

class UserStatsService {
  static final _db = FirebaseFirestore.instance;

  /// Llama esto cuando el usuario tome una foto para anlaizar por la IA 
  static Future<void> registerIAPhotoTake(String email ) async {
    final docRef = _db.collection('usario_stats').doc(email);
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    var usuario = Usuario.fromMap(snapshot.docs.first.data());

    await docRef.set({
      'usuario': email,
      'username': usuario.username,
      'FotosTaken': FieldValue.increment(1),
    }, SetOptions(merge: true)); // merge:true para no sobreescribir otros campos
  }

}