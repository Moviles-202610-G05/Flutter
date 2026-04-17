import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';


class RestaurantRepository {
  Future<List<Restaurant>> todosRestaurantes() async {
    final snapshot = await FirebaseFirestore.instance.collection('restaurants').get();
    print ("---------Revicion-------");
    print (snapshot.docs.map((doc) => Restaurant.fromMap(doc.data(), id: doc.id)).toList());
    return snapshot.docs.map((doc) => Restaurant.fromMap(doc.data(), id: doc.id)).toList();
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
}

