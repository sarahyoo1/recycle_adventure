import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final bool isVertical;
  final double offsetNegative;
  final double offsetPositive;
  Saw({
    this.isVertical = false,
    this.offsetNegative = 0,
    this.offsetPositive = 0,
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  static const double sawSpeed = 0.05;
  static const moveSpeed = 50;
  static const tileSize = 16;
  double moveDirection = 1; //initially sets direction to the right.
  double rangeNegative = 0;
  double rangePositive = 0;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = -1;
    add(CircleHitbox());

    //Sets movement range.
    if (isVertical) {
      //vertical movement
      rangeNegative = position.y - offsetNegative * tileSize;
      rangePositive = position.y + offsetPositive * tileSize;
    } else {
      //horizontal movement
      rangeNegative = position.x - offsetNegative * tileSize;
      rangePositive = position.x + offsetPositive * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
          amount: 8, stepTime: sawSpeed, textureSize: Vector2.all(38)),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    //Makes saw move.
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePositive) {
      moveDirection = -1;
    } else if (position.y <= rangeNegative) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePositive) {
      moveDirection = -1;
    } else if (position.x <= rangeNegative) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
