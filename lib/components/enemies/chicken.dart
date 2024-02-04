import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/enemy.dart';

enum State {
  idle,
  run,
  hit,
}

class Chicken extends Enemy {
  Chicken({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
  });

  static const _stompedHeight = 260.0;
  bool gotStopmed = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;

    add(
      RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),
      ),
    );
    _loadAnimations();
    calculateRange();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotStopmed) {
      _updateState();
      movement(dt);
    }
    super.update(dt);
  }

  void _loadAnimations() {
    idleAnimation = _spriteAnimation('Idle', 13);
    runAnimation = _spriteAnimation('Run', 14);
    hitAnimation = _spriteAnimation('Hit', 15)..loop = false;

    animations = {
      State.idle: idleAnimation,
      State.run: runAnimation,
      State.hit: hitAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Chicken/$state (32x34).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(32, 34),
      ),
    );
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;

    //Flips chicken depending on the player's direction.
    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() async {
    //when the bottom of the player hit chicken's top.
    // TODO: fix the error that player sometimes dies when stomped enemy.
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundVolume);
      }
      gotStopmed = true;
      current = State.hit;
      player.velocity.y = -_stompedHeight;
      await animationTicker?.completed;
      removeFromParent();
    } else {
      player.collidedWithEnemy();
    }
  }
}