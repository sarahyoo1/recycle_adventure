import 'package:flame/components.dart';
import 'package:pixel_adventure/components/traps/car.dart';

class CarSpawnManager extends Component {
  late Timer _timer;
  late Vector2 position;
  int direction;
  CarSpawnManager({
    required this.position,
    this.direction = -1, //defalut direction: left
  }) : super() {
    _timer = Timer(2, onTick: _spawnCars, repeat: true);
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

  void _spawnCars() {
    Car car = Car(
      position: position,
      size: Vector2(96, 48),
      direction: direction,
    );
    add(car);
  }
}
