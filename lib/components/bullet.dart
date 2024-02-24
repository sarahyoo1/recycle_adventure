import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  double speed;
  String imagePath;
  int animationAmount;
  bool moveVertically;
  double moveDirection;
  RectangleHitbox hitbox;
  Bullet({
    super.position,
    this.speed = 450,
    this.imagePath = "Bullet.png", //default bullet
    this.animationAmount = 1,
    this.moveVertically = false,
    required this.moveDirection,
    required this.hitbox,
  }) : super(
          size: Vector2(25, 25),
          anchor: Anchor.center,
        );

  late final Player player;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;

    updateBulletDirection();

    add(hitbox);

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(imagePath),
      SpriteAnimationData.sequenced(
        amount: animationAmount,
        stepTime: 0.2,
        textureSize: Vector2(16, 16),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    movement(dt);
    super.update(dt);
  }

  void movement(dt) {
    if (moveVertically) {
      position.y += speed * dt;
    } else {
      position.x += moveDirection * speed * dt;
    }

    if (position.y < -game.size.y ||
        position.x < 0 ||
        position.x > game.size.x) {
      removeFromParent();
    }
  }

  void updateBulletDirection() {
    if (moveDirection == 1) {
      flipHorizontallyAroundCenter();
    }
  }
}
