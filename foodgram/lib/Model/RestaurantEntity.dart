import 'dart:io';

class Restaurant{
  final String name;
  String image;
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
  final List<dynamic> tags;
  File? imagenFiel;
  final String id;


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
    required this.id

  });
  

  factory Restaurant.fromMap(Map<String, dynamic> map, {required String id}) {

    print(map);

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
      tags: map['tags'] ?? [],
      id: id ,
    
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
      'spotsA': spots,
      'tags': tags
    };
  }

  
  @override
  String toString() {
    return 'Restaurant(nombre: $name, direccion: $rating)';
  }

  

 

}
