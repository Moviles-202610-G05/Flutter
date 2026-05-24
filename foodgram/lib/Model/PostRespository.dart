import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:foodgram/Model/PostEntity.dart';
import 'package:foodgram/Model/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class PostRepository {

  // Singleton — garantiza una sola instancia del repositorio y su LRU cache en toda la app
  static final PostRepository _instance = PostRepository._internal();
  factory PostRepository() => _instance;
  PostRepository._internal();


  Future<List<Post>> todosPost(String usuario) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool hayInternet = connectivityResult != ConnectivityResult.none;
    print(usuario);

    if (hayInternet) {
      try {
        // Obtiene datos de Firebase
        final snapshot = await FirebaseFirestore.instance
        .collection('postss')
        .get();

        final posts = snapshot.docs
            .map((doc) => Post.fromMap(doc.data(), id: doc.id))
            .toList();

        // Guarda en SQLite (memoria del celular)
        _guardarSQLite(posts);
        return posts;

      } catch (e) {

        return await _postsLocales();
      }

    } else {
      return await _postsLocales();
    }
  }


// Lee desde SQLite
Future<List<Post>> _postsLocales() async {
  final datos = await DatabaseHelper.obtenerPosts();
  print("----estaaaaa----");
  print(datos);
 
  if (datos.isEmpty) return [];

  return datos.map((map) {
    
    final mutableMap = Map<String, dynamic>.from(map);
    final id = mutableMap.remove('id') as String;
    
    // Convierte tags de JSON string a List
    if (mutableMap['tags'] != null) {
      mutableMap['tags'] = jsonDecode(mutableMap['tags'] as String);
    }
     // towComents (JSON -> List<Coments>)
    if (mutableMap['towComents'] != null) {
      mutableMap['towComents'] = (jsonDecode(mutableMap['towComents']) as List);
    }

    return Post.fromMap(mutableMap, id: id);
  }).toList();
}



  Future<void> crearPost(Post post) async {
    await FirebaseFirestore.instance.collection('user').add(post.toMap());
  }

 Future<void> _guardarSQLite(List<Post> posts) async {
  final db = await DatabaseHelper.getDatabase();
  final batch = db.batch();

  for (final p in posts.take(15)) {
    final data = {
      'id': p.id,
      'userName': p.userName,
      'image': p.image,
      'color': p.color,
      'description': p.description,
      'likes': p.likes,
      'comments': p.comments,

      // List<String> -> JSON
      'tags': jsonEncode(p.tags),
      'email': p.email,
      'restaurantName': p.restaurantName,

      // List<Coments> -> JSON
      'towComents': jsonEncode(
        p.towComents.map((e) => e.toMap()).toList(),
      ),
    };

    batch.insert(
      'posts',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  await batch.commit(noResult: true);
}

}

