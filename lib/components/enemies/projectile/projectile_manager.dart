import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/enemies/projectile/projectile.dart';

class EnemyProjectileManager extends Component {
  late Timer _timer;
  late Vector2 position;
  late double limit;
  EnemyProjectileManager({
    required this.position,
    required this.limit,
  }) : super() {
    _timer = Timer(limit, onTick: _spawnProjectiles, repeat: true);
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

  void _spawnProjectiles() {
    Projectile projectile = Projectile(
      position: position,
      moveDirection: -1,
      hitbox: RectangleHitbox(
        collisionType: CollisionType.passive,
        position: Vector2(2, 9),
        size: Vector2(22, 10),
      ),
    );
    add(projectile);
  }
}
