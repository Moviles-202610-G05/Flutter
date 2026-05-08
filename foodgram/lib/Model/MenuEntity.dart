import 'dart:io';

import 'package:hive/hive.dart';

part 'MenuEntity.g.dart';

@HiveType(typeId: 2)
class Menu extends HiveObject{
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String price;
  @HiveField(2)
  final String description;
  @HiveField(3)
  String image;
  @HiveField(4)
  String restaurant;
  File? imagenFiel;
  @HiveField(5)
  final String category;

  @HiveField(6)
  bool pendingSync;
  

  Menu({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.restaurant,
    this.imagenFiel, 
    required this.category,
    this.pendingSync = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'image': image,
      'restaurant': restaurant,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      restaurant: map['restaurant']?? '',
      category: map['category']?? '',
    );
  }

  Future<void> setImagen(Future<String> subirImagen) async {
    image = await subirImagen;
  }
}