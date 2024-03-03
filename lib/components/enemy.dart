import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Enemy extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offsetPositive;
  final double offsetNegative;
  int lives;
  Enemy({
    super.position,
    super.size,
    this.offsetPositive = 0,
    this.offsetNegative = 0,
    this.lives = 1, //default lives
  });

  double stepTime = 0.05;
  double tileSize = 16;
  double moveSpeed = 55;

  double rangeNegative = 0;
  double rangePositive = 0;
  Vector2 velocity = Vector2.zero();
  Vector2 moveDirection = Vector2(1, 0);
  Vector2 targetDirection = Vector2(-1, 0);

  late final Player player = game.player;

  void calculateRange() {
    rangeNegative = position.x - offsetNegative * tileSize;
    rangePositive = position.x + offsetPositive * tileSize;
  }

//default movement
  void movement(dt) {
    velocity.x = 0;

    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double enemyOffset = (scale.x > 0) ? 0 : -width;

    if (isPlayerInRange()) {
      targetDirection.x =
          (player.x + playerOffset < position.x + enemyOffset) ? -1 : 1;
      velocity.x = targetDirection.x * moveSpeed;
    }

    //Changes enemy's direction when player changes direction.
    moveDirection.x = lerpDouble(moveDirection.x, targetDirection.x, 0.1) ?? 1;

    position.x += velocity.x * dt;
  }

  bool isPlayerInRange() {
    double playerOffsetX = (player.scale.x > 0) ? 0 : -player.width;

    return (player.x + playerOffsetX >= rangeNegative &&
        player.x + playerOffsetX <= rangePositive);
  } //player.y + player.height > position.y  --> this makes enemies stop when player is not on the ground.
}
