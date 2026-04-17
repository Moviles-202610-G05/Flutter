class Usuario {
  final String universityId;
  final String name;
  final String email;
  final String carrier;
  final String location;
  String roll = "ESTUDIANTE";
  final String password;
  final List<String> preferences;
  final String username;
  final double caloriesGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;
  final List<String> friends;

  Usuario({
    required this.universityId,
    required this.name,
    required this.email,
    required this.carrier,
    this.location = 'Carrier 1',
    required this.password,
    required this.preferences,
    required this.username,
    roll = "ESTUDIANTE",
    this.caloriesGoal = 2000,
    this.proteinGoal  = 150,
    this.carbsGoal    = 200,
    this.fatGoal      = 67,
    this.friends = const [],
  });

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
      'caloriesGoal': caloriesGoal,
      'proteinGoal':  proteinGoal,
      'carbsGoal':    carbsGoal,
      'fatGoal':      fatGoal,
      'friends': friends,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      universityId: map['universityId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      carrier: map['carrier'] ?? '',
      roll: map['roll'] ?? '',
      password: map['password'] ?? '',
      preferences: List<String>.from(map['preferences'] ?? []),
      username: map['username'],
      caloriesGoal: (map['caloriesGoal'] ?? 2000).toDouble(),
      proteinGoal:  (map['proteinGoal']  ?? 150).toDouble(),
      carbsGoal:    (map['carbsGoal']    ?? 200).toDouble(),
      fatGoal:      (map['fatGoal']      ?? 67).toDouble(),
      friends: List<String>.from(map['friends'] ?? []),
      location: map['location'] as String? ?? 'Carrier 1',
    );
  }

  void setRol(String s) {this.roll = s;}
}