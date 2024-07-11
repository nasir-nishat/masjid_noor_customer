// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_md.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserMdAdapter extends TypeAdapter<UserMd> {
  @override
  final int typeId = 0;

  @override
  UserMd read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserMd(
      userId: fields[0] as String?,
      email: fields[1] as String,
      passwordHash: fields[2] as String?,
      firstName: fields[3] as String?,
      lastName: fields[4] as String?,
      isAdmin: fields[5] as bool?,
      createdAt: fields[6] as DateTime?,
      phoneNumber: fields[7] as String,
      username: fields[8] as String?,
      profilePic: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserMd obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.passwordHash)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.isAdmin)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.username)
      ..writeByte(9)
      ..write(obj.profilePic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
