import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Enemy extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offsetPositive;
  final double offsetNegative;
  Enemy({
    super.position,
    super.size,
    this.offsetPositive = 0,
    this.offsetNegative = 0,
  });

  double stepTime = 0.05;
  double tileSize = 16;
  double runSpeed = 80;

  double rangeNegative = 0;
  double rangePositive = 0;
  Vector2 velocity = Vector2.zero();
  double moveDirection = 1;
  double targetDirection = -1;

  late final Player player = game.player;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation hitAnimation;

  void calculateRange() {
    rangeNegative = position.x - offsetNegative * tileSize;
    rangePositive = position.x + offsetPositive * tileSize;
  }

  void movement(dt) {
    //sets velocity to be 0;
    velocity.x = 0;

    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double enemyOffset = (scale.x > 0) ? 0 : -width;

    if (isPlayerInRange()) {
      //player is in the range of enemy.
      targetDirection =
          (player.x + playerOffset < position.x + enemyOffset) ? -1 : 1;
      velocity.x = targetDirection * runSpeed;
    }

    //Changes enemy's direction when player changes direction.
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;

    position.x += velocity.x * dt;
  }

  //Checks if player is within the range of enemy's detection.
  bool isPlayerInRange() {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    return (player.x + playerOffset >= rangeNegative &&
        player.x + playerOffset <= rangePositive &&
        player.y + player.height > position.y);
  }
}
