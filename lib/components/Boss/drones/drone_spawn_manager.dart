import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:recycle_adventure/components/Boss/drones/drone1.dart';
import 'package:recycle_adventure/components/Boss/drones/drone2.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class DroneSpawnManager extends Component with HasGameRef<RecycleAdventure> {
  late Timer timer;
  late Vector2 droneOnePosition;
  late Vector2 droneTwoPosition;
  late double limit;
  DroneSpawnManager({
    required this.droneOnePosition,
    required this.droneTwoPosition,
    required this.limit,
  }) : super() {
    timer = Timer(limit, onTick: _spawnRandomDrone, repeat: true);
  }

  @override
  void onRemove() {
    super.onRemove();
    timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }

  void _spawnRandomDrone() {
    int rd = Random().nextInt(3);
    switch (rd) {
      case 0:
        _spawnDrone1();
        break;
      case 1:
        _spawnDrone2();
        break;
    }
  }

  void _spawnDrone1() {
    if (game.isSoundEffectOn) {
      FlameAudio.play('boss-drone-spawn.mp3', volume: game.soundEffectVolume);
    }
    DroneOne drone1 = DroneOne(
      position: droneOnePosition,
    );

    add(drone1);
  }

  void _spawnDrone2() {
    if (game.isSoundEffectOn) {
      FlameAudio.play('boss-drone-spawn.mp3', volume: game.soundEffectVolume);
    }
    DroneTwo drone2 = DroneTwo(
      position: droneTwoPosition,
    );

    add(drone2);
  }
}
