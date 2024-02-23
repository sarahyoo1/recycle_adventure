import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum Color {
  red,
  orange,
  blue,
  green,
}

class Car extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  int direction;
  Car({
    super.position,
    super.size,
    required this.direction,
  });

  late Player player;
  late final double spawnPointX;

  late final SpriteAnimation _redCarSpriteAnimation;
  late final SpriteAnimation _orangeCarSpriteAnimation;
  late final SpriteAnimation _blueCarSpriteAnimation;
  late final SpriteAnimation _greenCarSpriteAnimation;

  late double speed;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    debugMode = true;
    player = game.player;
    spawnPointX = position.x;
    _loadSpriteAnimations();
    _applyRandomSpeed();

    add(
      RectangleHitbox(
        position: Vector2(8, 16),
        size: Vector2(20, 19),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
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
        textureSize: Vector2(48, 21),
      ),
    );
  }

  void movement(double dt) {
    position.x += direction * speed * dt;

    if (position.x < -96) {
      position.x = spawnPointX + 100;
      removeFromParent();
    }
  }

  void collidedWithPlayer() {
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
}
