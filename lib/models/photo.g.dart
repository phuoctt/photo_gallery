// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoAdapter extends TypeAdapter<PhotoModel> {
  @override
  final int typeId = 1;

  @override
  PhotoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoModel(
      name: fields[0] as String,
      date: fields[1] as DateTime,
      path: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
