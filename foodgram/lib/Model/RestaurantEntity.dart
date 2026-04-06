import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgram/Model/ReviewsEntity.dart';


class Restaurant{
  final String name;
  final String image;
  final double rating;
  final String price;
  final String cuisine;
  final String time;
  final String distance;
  final double long;
  final double lat;
  final String badge;
  final String badge2;
  final int numberReviews;
  final String description;
  final String direction;
  final int spots;
  final int spotsA;


  Restaurant({
    required this.name,
    required this.image,
    required this.rating,
    required this.price,
    required this.cuisine,
    required this.time,
    required this.distance,
    required this.long,
    required this.lat, 
    required this.badge, 
    required this.badge2,
    required this.numberReviews, 
    required this.description,
    required this.direction,
    required this.spots,
    required this.spotsA,

  });
  

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    print("-----REVICION-----11");
    return Restaurant(
      name: map['name'] ?? '',
      image: map['restaurantImage'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      price: map['price'] ?? '',
      cuisine: map['cuisine'] ?? '',
      time: map['time'] ?? '',
      distance: map['distance'] ?? '',
      long: (map['long'] ?? 0).toDouble(),
      lat: (map['lat'] ?? 0).toDouble(),
      numberReviews: map['nuberReviews'],
      badge: map['badge'] ?? '', 
      badge2: map['badge2'] ?? '',
      description: map['description'] ?? '',
      direction: map['direction']??'',
      spots: map['spots'],
      spotsA: map['spotsA'],
    
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'rating': rating,
      'price': price,
      'cuisine': cuisine,
      'time': time,
      'distance': distance,
      'long': long,
      'lat': lat,
      'badge': badge,
      'badge2': badge2,
      'numberReviews': numberReviews.toString(),
      'description': description,
      'direction': direction,
      'spots': spots,
      'spotsA': spots
    };
  }

  
  @override
  String toString() {
    return 'Restaurant(nombre: $name, direccion: $rating)';
  }

 

}
