// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData()
      ..health = fields[0] as int
      ..itemsCollected = fields[1] as int
      ..totalItemsNum = fields[2] as int
      ..isOkToNextFloor = fields[3] as bool
      ..showControls = fields[4] as bool
      ..isSoundEffectOn = fields[5] as bool
      ..isMusicOn = fields[6] as bool
      ..soundEffectVolume = fields[7] as double
      ..musicVolume = fields[8] as double
      ..currentFloorIndex = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.health)
      ..writeByte(1)
      ..write(obj.itemsCollected)
      ..writeByte(2)
      ..write(obj.totalItemsNum)
      ..writeByte(3)
      ..write(obj.isOkToNextFloor)
      ..writeByte(4)
      ..write(obj.showControls)
      ..writeByte(5)
      ..write(obj.isSoundEffectOn)
      ..writeByte(6)
      ..write(obj.isMusicOn)
      ..writeByte(7)
      ..write(obj.soundEffectVolume)
      ..writeByte(8)
      ..write(obj.musicVolume)
      ..writeByte(9)
      ..write(obj.currentFloorIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
