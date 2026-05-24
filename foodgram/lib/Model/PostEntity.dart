import 'dart:io';

import 'package:foodgram/Model/ComentsEntity.dart';


class Post {
  final String userName;

  String image;

  final String color;

  final String description;

  final List<String> tags;
  final int likes;
  final int comments;
  final List<Coments> towComents;
  final String restaurantName; 
  
  File? imagenFiel;

  final String id;

  final String email;


  Post({ required this.userName, required this.image, this.imagenFiel, required this.color, required this.description, required this.tags, required this.likes, required this.comments, required this.towComents, required this.id, required this.restaurantName, required this.email});
   

  factory Post.fromMap(Map<String, dynamic> map, {required String id}) {

    return Post(
      userName: map['userName'] ?? '',
      image: map['image'] ?? '',
      color: map['color'] ?? '',
      description: map['description'] ?? '',
      likes: (map['likes'] ?? 0).toInt(),
      comments: (map['comments'] ?? 0).toInt(),
      tags: (map['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      towComents: (map['towComents'] as List?)?.map((e) => Coments.fromMap(e)).toList() ?? [],
      id: id, 
      restaurantName:  map['restaurantName']??"", email: map['email']??'',
    );
  }



  Map<String, dynamic> toMap() {
  return {
    'userName': userName,
    'image': image,
    'color': color,
    'description': description,
    'likes': likes,
    'comments': comments,
    'tags': tags,
    'towComents': towComents.map((e) => e.toMap()).toList(),
    'restaurantName': restaurantName,
    'email': email
  };
}

  
}
