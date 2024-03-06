import 'package:hive/hive.dart';
part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends HiveObject {
  @HiveField(0)
  int health = 0;
  @HiveField(1)
  int itemsCollected = 0;
  @HiveField(2)
  int totalItemsNum = 0;
  @HiveField(3)
  bool isOkToNextFloor = false;
  @HiveField(4)
  bool showControls = false; //turns on and off joysticks and other buttons
  @HiveField(5)
  bool isSoundEffectOn = true;
  @HiveField(6)
  bool isMusicOn = true;
  @HiveField(7)
  double soundEffectVolume = 1.0;
  @HiveField(8)
  double musicVolume = 1.0;
  @HiveField(9)
  int currentFloorIndex = 0;
}
