import 'package:hive/hive.dart';

part 'UsuarioEntity.g.dart';

@HiveType(typeId: 1) // cada entidad necesita un typeId único
class Usuario extends HiveObject {
  @HiveField(0)
  String universityId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String carrier;

  @HiveField(4)
  String location;

  @HiveField(5)
  String roll;

  @HiveField(6)
  String password;

  @HiveField(7)
  List<String> preferences;

  @HiveField(8)
  String username;

  @HiveField(9)
  double caloriesGoal;

  @HiveField(10)
  double proteinGoal;

  @HiveField(11)
  double carbsGoal;

  @HiveField(12)
  double fatGoal;

  @HiveField(13)
  List<String> friends;

  @HiveField(14)
  bool pendingSync; // 🔑 para saber si falta sincronizar

  Usuario({
    required this.universityId,
    required this.name,
    required this.email,
    required this.carrier,
    this.location = 'Carrier 1',
    this.roll = "ESTUDIANTE",
    required this.password,
    required this.preferences,
    required this.username,
    this.caloriesGoal = 2000,
    this.proteinGoal  = 150,
    this.carbsGoal    = 200,
    this.fatGoal      = 67,
    this.friends = const [],
    this.pendingSync = false,
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