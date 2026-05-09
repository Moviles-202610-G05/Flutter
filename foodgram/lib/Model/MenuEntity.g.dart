// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MenuEntity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuAdapter extends TypeAdapter<Menu> {
  @override
  final int typeId = 3;

  @override
  Menu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Menu(
      name: fields[0] as String,
      price: fields[1] as String,
      description: fields[2] as String,
      image: fields[3] as String,
      restaurant: fields[4] as String,
      category: fields[5] as String,
      pendingSync: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Menu obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.restaurant)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.pendingSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
