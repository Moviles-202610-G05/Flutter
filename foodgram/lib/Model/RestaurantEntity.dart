import 'dart:io';

import 'package:hive/hive.dart';
part 'RestaurantEntity.g.dart';

@HiveType(typeId: 2)
class Restaurant extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  String image;

  @HiveField(2)
  final double rating;

  @HiveField(3)
  final String price;

  @HiveField(4)
  final String cuisine;

  @HiveField(5)
  final String time;

  @HiveField(6)
  final String distance;

  @HiveField(7)
  final double long;

  @HiveField(8)
  final double lat;

  @HiveField(9)
  final String badge;

  @HiveField(10)
  final String badge2;

  @HiveField(11)
  final int numberReviews;

  @HiveField(12)
  final String description;

  @HiveField(13)
  final String direction;

  @HiveField(14)
  final int spots;

  @HiveField(15)
  final int spotsA;

  @HiveField(16)
  final List<String> tags;

  File? imagenFiel;
  @HiveField(17)
  final String id;

  @HiveField(18)
  bool pendingSync;


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
    this.imagenFiel,
    required this.tags,
    required this.id,
    this.pendingSync = true,

  });
  

  factory Restaurant.fromMap(Map<String, dynamic> map, {required String id}) {

    return Restaurant(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      rating: double.tryParse(map['rating']?.toString() ?? '0.0') ?? 0.0,
      price: map['price'] ?? '',
      cuisine: map['cuisine'] ?? '',
      time: map['time'] ?? '',
      distance: map['distance'] ?? '',
      long: (map['long'] ?? 0).toDouble(),
      lat: (map['lat'] ?? 0).toDouble(),
      numberReviews: int.tryParse(map['nuberReviews']?.toString() ?? '0') ?? 0,
      badge: map['badge'] ?? '', 
      badge2: map['badge2'] ?? '',
      description: map['description'] ?? '',
      direction: map['direction']??'',
      spots: map['spots']?? 0,
      spotsA: map['spotsA'] ?? 0,
      tags: (map['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      id: id ,
    
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'spotsA': spots,
      'tags': tags
    };
  }

  
  @override
  String toString() {
    return 'Restaurant(nombre: $name, direccion: $rating)';
  }

  

 

}
