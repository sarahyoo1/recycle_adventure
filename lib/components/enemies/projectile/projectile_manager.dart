import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:recycle_adventure/components/enemies/projectile/projectile.dart';

class EnemyProjectileManager extends Component {
  late Timer timer;
  Vector2 position;
  double limit;
  double moveDirection;
  EnemyProjectileManager({
    required this.position,
    required this.limit,
    required this.moveDirection,
  }) : super() {
    timer = Timer(limit, onTick: _spawnProjectiles, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    timer.start();
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

  void _spawnProjectiles() {
    Projectile projectile = Projectile(
      position: position,
      moveDirection: moveDirection,
      hitbox: RectangleHitbox(
        collisionType: CollisionType.passive,
        position: Vector2(2, 9),
        size: Vector2(22, 10),
      ),
    );
    add(projectile);
  }
}
