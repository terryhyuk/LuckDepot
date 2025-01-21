// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverAdapter extends TypeAdapter<Driver> {
  @override
  final int typeId = 0;

  @override
  Driver read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Driver(
      driverNum: (fields[0] as num).toInt(),
      name: fields[1] as String,
      phone: (fields[2] as num).toInt(),
      email: fields[3] as String,
      isRegular: fields[4] as bool,
      id: fields[5] as String,
      password: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Driver obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.driverNum)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.isRegular)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
