class Ususario {
  final String universityId;
  final String name;
  final String email;
  final String carrier;
  String roll = "ESTUDIANTE";
  final String password;
  final List<String> preferences;
  final  String username;

  Ususario({
    required this.universityId,
    required this.name,
    required this.email,
    required this.carrier,
    required this.password,
    required this.preferences,
    required this.username, 
    roll = "ESTUDIANTE",
  });

  // Convierte el objeto en un Map
  Map<String, dynamic> toMap() {
    return {
      'universityId': universityId,
      'name': name,
      'email': email,
      'carrier': carrier,
      'roll': roll,
      'password': password,
      'preferences': preferences,
      'username': username,
    };
  }

  // Crea un objeto User desde un Map (ej. al leer de Firebase)
  factory Ususario.fromMap(Map<String, dynamic> map) {
    return Ususario(
      universityId: map['universityId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      carrier: map['carrier'] ?? '',
      roll: map['roll'] ?? '',
      password: map['password'] ?? '',
      preferences: List<String>.from(map['preferences'] ?? []),
      username: map['username']
    );
  }

  void setRol(String s) {this.roll = s;}
}