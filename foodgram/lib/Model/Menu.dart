class Menu {
  final String name;
  final String price;
  final String description;
  final String image;

  Menu({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  // Convertir objeto a Map (para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  // Crear objeto desde Map (cuando leemos de Firestore)
  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
    );
  }
}