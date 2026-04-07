import 'dart:io';

class Menu {
  final String name;
  final String price;
  final String description;
  String image;
  final String restaurant;
  File? imagenFiel;
  final String category;

  Menu({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.restaurant,
    this.imagenFiel, required 
    this.category,
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
    this.image = await subirImagen;
  }
}