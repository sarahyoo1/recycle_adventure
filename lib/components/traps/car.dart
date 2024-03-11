import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:recycle_adventure/components/player.dart';
import 'package:recycle_adventure/components/utils.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

enum Color {
  red,
  orange,
  blue,
  green,
}

class Car extends SpriteAnimationGroupComponent
    with HasGameRef<RecycleAdventure> {
  int direction;
  bool isPlatform;
  Car({
    super.position,
    super.size,
    required this.direction,
    this.isPlatform = false,
  });

  late Player player;

  late final SpriteAnimation _redCarSpriteAnimation;
  late final SpriteAnimation _orangeCarSpriteAnimation;
  late final SpriteAnimation _blueCarSpriteAnimation;
  late final SpriteAnimation _greenCarSpriteAnimation;

  late double speed;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    debugMode = false;
    player = game.player;

    _loadSpriteAnimations();
    if (direction == 1) {
      flipHorizontallyAroundCenter();
    }
    _applyRandomSpeed();

    add(
      RectangleHitbox(
        position: Vector2(8, 16),
        size: Vector2(70, 20),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!player.gotHit && !player.dead) {
      _checkVerticalCollisions(dt);
    }
    movement(dt);
  }

  void _loadSpriteAnimations() {
    _redCarSpriteAnimation = _spriteAnimation('red');
    _orangeCarSpriteAnimation = _spriteAnimation('orange');
    _blueCarSpriteAnimation = _spriteAnimation('blue');
    _greenCarSpriteAnimation = _spriteAnimation('green');

    animations = {
      Color.red: _redCarSpriteAnimation,
      Color.orange: _orangeCarSpriteAnimation,
      Color.blue: _blueCarSpriteAnimation,
      Color.green: _greenCarSpriteAnimation,
    };

    _applyRandomColor();
  }

  SpriteAnimation _spriteAnimation(String color) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Cars/car-$color.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.05,
        textureSize: Vector2(48, 18),
      ),
    );
  }

  void movement(double dt) {
    velocity.x = direction * speed;
    position.x += velocity.x * dt;

    if (direction == -1) {
      if (position.x < -96) {
        removeFromParent();
      }
    } else if (direction == 1) {
      if (position.x > 736) {
        removeFromParent();
      }
    }
  }

  void collidedWithPlayer() {
    game.health--;
    player.respawn();
  }

  void _applyRandomColor() {
    int randNum = Random().nextInt(3); //from 0 to 3.

    switch (randNum) {
      case 0:
        current = Color.red;
        break;
      case 1:
        current = Color.orange;
        break;
      case 2:
        current = Color.blue;
        break;
      case 3:
        current = Color.green;
        break;
    }
  }

  void _applyRandomSpeed() {
    speed = Random().nextDouble() * 100 + 80; //from 80 to 180.
  }

  void _checkVerticalCollisions(dt) {
    if (checkCollision(player, this)) {
      if (player.velocity.y > 0) {
        player.velocity.y = 0;
        player.position.y = position.y -
            player.hitboxSetting.height -
            player.hitboxSetting.offsetY;
        player.isOnGround = true;
        player.position.x += velocity.x * dt;
      }

      if (player.velocity.y < 0) {
        player.isOnGround = false;
        player.velocity.y = 0;
        player.position.y = position.y + height - player.hitboxSetting.offsetY;
      }
    }
  }
}
