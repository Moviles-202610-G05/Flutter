// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestaurantEntity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantAdapter extends TypeAdapter<Restaurant> {
  @override
  final int typeId = 2;

  @override
  Restaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Restaurant(
      name: fields[0] as String,
      image: fields[1] as String,
      rating: fields[2] as double,
      price: fields[3] as String,
      cuisine: fields[4] as String,
      time: fields[5] as String,
      distance: fields[6] as String,
      long: fields[7] as double,
      lat: fields[8] as double,
      badge: fields[9] as String,
      badge2: fields[10] as String,
      numberReviews: fields[11] as int,
      description: fields[12] as String,
      direction: fields[13] as String,
      spots: fields[14] as int,
      spotsA: fields[15] as int,
      tags: (fields[16] as List).cast<String>(),
      id: fields[17] as String,
      pendingSync: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Restaurant obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.cuisine)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.distance)
      ..writeByte(7)
      ..write(obj.long)
      ..writeByte(8)
      ..write(obj.lat)
      ..writeByte(9)
      ..write(obj.badge)
      ..writeByte(10)
      ..write(obj.badge2)
      ..writeByte(11)
      ..write(obj.numberReviews)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.direction)
      ..writeByte(14)
      ..write(obj.spots)
      ..writeByte(15)
      ..write(obj.spotsA)
      ..writeByte(16)
      ..write(obj.tags)
      ..writeByte(17)
      ..write(obj.id)
      ..writeByte(18)
      ..write(obj.pendingSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
