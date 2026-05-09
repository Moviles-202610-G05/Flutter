import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/DatabaseHelper.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:collection';

class RestaurantRepository {

  // Singleton — garantiza una sola instancia del repositorio y su LRU cache en toda la app
  static final RestaurantRepository _instance = RestaurantRepository._internal();
  factory RestaurantRepository() => _instance;
  RestaurantRepository._internal();

  // Caching — LRU: almacena hasta 20 restaurantes en memoria durante la sesion
  static const int _lruMaxSize = 20;
  final LinkedHashMap<String, Restaurant> _lruCache = LinkedHashMap();

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

        // Caching — LRU: puebla el cache en memoria con los restaurantes recien cargados
        for (final r in restaurantes) {
          _putInLru(r.id, r);
        }

        // Guarda en SQLite (memoria del celular)
        _guardarSQLite(restaurantes);
        return restaurantes;

      } catch (e) {
        return await _restaurantesLocales();
      }

    } else {
      return await _restaurantesLocales();
    }
  }


// Lee desde SQLite
Future<List<Restaurant>> _restaurantesLocales() async {
  final datos = await DatabaseHelper.obtenerRestaurantes();
 
  if (datos.isEmpty) return [];

  return datos.map((map) {
    
    final mutableMap = Map<String, dynamic>.from(map);
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
    // Caching — LRU: busca por nombre en memoria antes de ir a Firestore
    final fromCache = _lruCache.values.where((r) => r.name == nombre).firstOrNull;
    if (fromCache != null) {
      _getFromLru(fromCache.id); 
      return fromCache;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('name', isEqualTo: nombre)
        .get();
    final restaurant = snapshot.docs
        .map((doc) => Restaurant.fromMap(doc.data(), id: doc.id))
        .toList()[0];

    // Caching — LRU: guarda en memoria el restaurante recien consultado
    _putInLru(restaurant.id, restaurant);
    return restaurant;
  }

  final _geo = GeoFlutterFire();

  Stream<List<Restaurant>> getRestaurantsByProximity(double lat, double lng, double radius) {
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);
    var collectionReference =  FirebaseFirestore.instance.collection('restaurants');

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
  return datos;
  }

  // Caching — LRU: busca el restaurante en memoria y lo mueve al frente si existe
  Restaurant? _getFromLru(String id) {
    final item = _lruCache.remove(id);
    if (item != null) {
      _lruCache[id] = item;
    } else {
    }
    return item;
  }

  // Caching — LRU: inserta en memoria y descarta el mas antiguo si se supera el limite
  void _putInLru(String id, Restaurant restaurant) {
    if (_lruCache.length >= _lruMaxSize) {
      _lruCache.remove(_lruCache.keys.first);
    }
    _lruCache[id] = restaurant;
  }
  
  Future<void> _guardarSQLite(List<Restaurant> restaurantes) async {
      final db = await DatabaseHelper.getDatabase();
      final batch = db.batch();

      for (final r in restaurantes.take(50)) {
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
        batch.insert(
          'restaurants',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    }

}

