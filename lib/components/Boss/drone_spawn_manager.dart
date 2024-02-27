import 'dart:math';

import 'package:flame/components.dart';
import 'package:pixel_adventure/components/Boss/drones/drone1.dart';
import 'package:pixel_adventure/components/Boss/drones/drone2.dart';

class DroneSpawnManager extends Component {
  late Timer _timer;
  late Vector2 droneOnePosition;
  late Vector2 droneTwoPosition;
  late double limit;
  DroneSpawnManager({
    required this.droneOnePosition,
    required this.droneTwoPosition,
    required this.limit,
  }) : super() {
    _timer = Timer(limit, onTick: _spawnRandomDrone, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
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
    DroneOne drone1 = DroneOne(
      position: droneOnePosition,
    );

    add(drone1);
  }

  void _spawnDrone2() {
    DroneTwo drone2 = DroneTwo(
      position: droneTwoPosition,
    );

    add(drone2);
  }
}
