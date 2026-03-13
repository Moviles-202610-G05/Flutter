import 'package:cloud_firestore/cloud_firestore.dart';

import 'reviews.dart';
import 'menu.dart';

class Restaurant {
  final String restaurantName;
  final String image;
  final double rating;
  final String price;
  final String cuisine;
  final String time;
  final List<Reviews> reviews;
  final List<Menu> menu;
  final String distance;
  final double long;
  final double lat;
  final String badge;
  final String badge2;
  final int numberReviews;
  final String description;


  Restaurant({
    required this.restaurantName,
    required this.image,
    required this.rating,
    required this.price,
    required this.cuisine,
    required this.time,
    required this.reviews,
    required this.menu,
    required this.distance,
    required this.long,
    required this.lat, 
    required this.badge, 
    required this.badge2,
    required this.numberReviews, 
    required this.description

  });

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    print("-----REVICION-----11");
    return Restaurant(
      restaurantName: map['restaurantName'] ?? '',
      image: map['restaurantImage'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      price: map['price'] ?? '',
      cuisine: map['cuisine'] ?? '',
      time: map['time'] ?? '',
      reviews: (map['reviews'] as List<dynamic>? ?? [])
        .map((r) => Reviews.fromMap(r as Map<String, dynamic>))
        .toList(),
      menu: (map['menu'] as List<dynamic>? ?? [])
        .map((m) => Menu.fromMap(m as Map<String, dynamic>))
        .toList(),
      distance: map['distance'] ?? '',
      long: (map['long'] ?? 0).toDouble(),
      lat: (map['lat'] ?? 0).toDouble(),
      numberReviews: map['reviews'].length,
      badge: map['badge'] ?? '', 
      badge2: map['badge2'] ?? '',
      description: map['description'] ?? '',
    
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'name': restaurantName,
      'image': image,
      'rating': rating,
      'price': price,
      'cuisine': cuisine,
      'time': time,
      'reviews': reviews.map((r) => r.toMap()).toList(),
      'menu': menu.map((m) => m.toMap()).toList(),
      'distance': distance,
      'long': long,
      'lat': lat,
      'badge': badge,
      'badge2': badge2,
      'numberReviews': numberReviews.toString(),
      'description': description

    };
  }

  /// Trae todos los restaurantes desde Firestore
  static Future<List<Restaurant>> todosRestaurantes() async {
    final snapshot = await FirebaseFirestore.instance.collection('restaurants').get();
    print("Número de documentos: ${snapshot.docs.length}");

    List<Restaurant> restaurantes = [];

    for (var doc in snapshot.docs) {
      try {
        // Intentamos convertir cada documento individualmente
        final data = doc.data();
        print("Procesando documento ID: ${doc.id}");
        restaurantes.add(Restaurant.fromMap(data));
      } catch (e) {
        // ESTO te dirá exactamente qué campo está mal
        print("❌ ERROR en el documento ${doc.id}: $e");
      }
    }

    print("----Holaaa----"); //
    return restaurantes;
  }

  @override
  String toString() {
    return 'Restaurant(nombre: $restaurantName, direccion: $rating)';
  }

}
