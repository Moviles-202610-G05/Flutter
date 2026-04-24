import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/databaseHelper.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:sqflite/sqflite.dart';


class RestaurantRepository {
  Future<List<Restaurant>> todosRestaurantes() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool hayInternet = connectivityResult != ConnectivityResult.none;

    if (hayInternet) {
      try {
        // Obtiene datos de Firebase
        final snapshot = await FirebaseFirestore.instance
            .collection('restaurants')
            .get();

        final restaurantes = snapshot.docs
            .map((doc) => Restaurant.fromMap(doc.data(), id: doc.id))
            .toList();

        // Guarda en SQLite (memoria del celular)
        _guardarSQLite(restaurantes);
        

        print("✅ Datos desde Firebase y base local actualizada");
        return restaurantes;

      } catch (e) {
        print("❌ Error con Firebase, usando base local: $e");
        return await _restaurantesLocales();
      }

    } else {
      print("📴 Sin internet, usando base de datos local");
      return await _restaurantesLocales();
    }
  }


// Lee desde SQLite
Future<List<Restaurant>> _restaurantesLocales() async {
  final datos = await DatabaseHelper.obtenerRestaurantes();
 
  if (datos.isEmpty) return [];


  return datos.map((map) {
    
    final mutableMap = Map<String, dynamic>.from(map);
    print( mutableMap);
    final id = mutableMap.remove('id') as String;
    
    // Convierte tags de JSON string a List
    if (mutableMap['tags'] != null) {
      mutableMap['tags'] = jsonDecode(mutableMap['tags'] as String);
    }

    return Restaurant.fromMap(mutableMap, id: id);
  }).toList();
}

  Future<void> crearRestaurante(Restaurant restaurante) async {
    GeoFirePoint point = _geo.point(latitude: restaurante.lat, longitude: restaurante.long);
    await FirebaseFirestore.instance.collection('restaurants').add({...restaurante.toMap(), "position": point.data,});
  }

 

  Future<Restaurant> restaurante(String nombre) async {
    final snapshot = await FirebaseFirestore.instance.collection('restaurants').where('name', isEqualTo: nombre).get();
    return snapshot.docs.map((doc) => Restaurant.fromMap(doc.data(), id: doc.id)).toList()[0];
  }

  final _geo = GeoFlutterFire();

  /// Busca restaurantes en un radio de X kilómetros
  Stream<List<Restaurant>> getRestaurantsByProximity(double lat, double lng, double radius) {
    // 1. Definimos el centro de la búsqueda
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);

    // 2. Referencia a la colección
    var collectionReference =  FirebaseFirestore.instance.collection('restaurants');

    // 3. Realizamos la consulta geoespacial
    // 'position' es el nombre del campo en Firestore que contiene el geohash
  var datos =  _geo.collection(collectionRef: collectionReference)
    .within(
      center: center, 
      radius: radius, 
      field: 'position', 
      strictMode: true
    ).map((List<DocumentSnapshot> documentList) {
      // Convertimos cada documento a un objeto Restaurant
      return documentList.map((doc) => 
        Restaurant.fromMap(doc.data() as Map<String, dynamic>, id: doc.id)
      ).toList();
    }); 
  print ("----Revisar----");
  print (datos);
  return datos;
  }
  
  Future<void> _guardarSQLite(List<Restaurant> restaurantes) async {
      final db = await DatabaseHelper.getDatabase();
      final batch = db.batch();

      for (final r in restaurantes) {
        final data = {
          'id' : r.id,
          'name': r.name,
          'image': r.image,
          'rating': r.rating,
          'price': r.price,
          'cuisine': r.cuisine,
          'time': r.time,
          'distance': r.distance,
          'long': r.long,
          'lat': r.lat,
          'badge': r.badge,
          'badge2': r.badge2,
          'numberReviews': r.numberReviews,
          'description': r.description,
          'direction': r.direction,
          'spots': r.spots,
          'spotsA': r.spotsA,
          'tags': jsonEncode(r.tags), // 👈 List a JSON string
        };
        print("----------------------");
        print("Data completa: $data");
        batch.insert(
          'restaurants',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    }

}

