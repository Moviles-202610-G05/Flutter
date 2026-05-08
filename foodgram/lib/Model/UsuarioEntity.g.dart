// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsuarioEntity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 1;

  @override
  Usuario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usuario(
      universityId: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      carrier: fields[3] as String,
      location: fields[4] as String,
      roll: fields[5] as String,
      password: fields[6] as String,
      preferences: (fields[7] as List).cast<String>(),
      username: fields[8] as String,
      caloriesGoal: fields[9] as double,
      proteinGoal: fields[10] as double,
      carbsGoal: fields[11] as double,
      fatGoal: fields[12] as double,
      friends: (fields[13] as List).cast<String>(),
      pendingSync: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.universityId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.carrier)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.roll)
      ..writeByte(6)
      ..write(obj.password)
      ..writeByte(7)
      ..write(obj.preferences)
      ..writeByte(8)
      ..write(obj.username)
      ..writeByte(9)
      ..write(obj.caloriesGoal)
      ..writeByte(10)
      ..write(obj.proteinGoal)
      ..writeByte(11)
      ..write(obj.carbsGoal)
      ..writeByte(12)
      ..write(obj.fatGoal)
      ..writeByte(13)
      ..write(obj.friends)
      ..writeByte(14)
      ..write(obj.pendingSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
