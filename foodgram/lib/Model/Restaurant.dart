import 'package:cloud_firestore/cloud_firestore.dart';

import 'reviews.dart';
import 'menu.dart';

class Restaurant {
  final String restaurantName;
  final String restaurantImage;
  final double rating;
  final String price;
  final String cuisine;
  final String time;
  final List<Reviews> reviews;
  final List<Menu> menu;
  final String distance;
  final dynamic long;
  final dynamic lat;
  final String badge;
  final String badge2;

  Restaurant({
    required this.restaurantName,
    required this.restaurantImage,
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
  });

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      restaurantName: map['restaurantName'] ?? '',
      restaurantImage: map['restaurantImage'] ?? '',
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
      badge: map['badge'] ?? '',
      badge2: map['badge2'] ?? '',
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'restaurantImage': restaurantImage,
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
    };
  }

  /// Trae todos los restaurantes desde Firestore
  static Future<List<Restaurant>> todosRestaurantes() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('restaurants').get();

    return snapshot.docs
        .map((doc) => Restaurant.fromMap(doc.data()))
        .toList();
  }
}
