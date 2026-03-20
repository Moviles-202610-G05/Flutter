import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UtilitisFirebase {
  Future<String> subirImagen(File imagen) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('restaurant_photos/${DateTime.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putFile(imagen);
    return await storageRef.getDownloadURL();
  }
}