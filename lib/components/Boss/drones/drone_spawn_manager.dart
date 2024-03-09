import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:recycle_adventure/components/Boss/drones/drone1.dart';
import 'package:recycle_adventure/components/Boss/drones/drone2.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class DroneSpawnManager extends Component with HasGameRef<RecycleAdventure> {
  late Timer timer;
  late double limit;
  DroneSpawnManager({
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

  Vector2 _randomPosition() {
    double rd = Random().nextDouble() * 400;
    return Vector2(rd, 40);
  }

  void _spawnRandomDrone() {
    int rd = Random().nextInt(2);
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
      position: _randomPosition(),
    );

    add(drone1);
  }

  void _spawnDrone2() {
    if (game.isSoundEffectOn) {
      FlameAudio.play('boss-drone-spawn.mp3', volume: game.soundEffectVolume);
    }
    DroneTwo drone2 = DroneTwo(
      position: _randomPosition(),
    );

    add(drone2);
  }
}
