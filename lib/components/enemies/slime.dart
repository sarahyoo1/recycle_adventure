import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/enemy.dart';

enum State {
  idle,
  hit,
  run,
  particles,
}

class Slime extends Enemy {
  Slime({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _particlesAnimation;

  static const _stompedHeight = 260.0;
  static const _runSpeed = 30;
  bool gotStopmed = false;
  bool hitboxActive = true;
  RectangleHitbox? hitbox;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;

    //add rectangle hitbox.
    if (hitboxActive) {
      hitbox = RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),
      );
    }
    add(hitbox!);

    _loadAnimations();
    calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateState();
    movement(dt);

    super.update(dt);
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle-Run', 10);
    _runAnimation = _spriteAnimation('Idle-Run', 10);
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;
    _particlesAnimation = _specialSpriteAnimation('Particles', 4);

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
      State.particles: _particlesAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Slime/$state (44x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(44, 30),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Slime/$state (16x16).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.27,
        textureSize: Vector2(16, 16),
      ),
    );
  }

  void _updateState() {
    if (!gotStopmed) {
      current = (velocity.x != 0) ? State.run : State.idle;
    }

    //Flips enemy depending on the player's direction.
    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  @override
  void collidedWithPlayer() async {
    // TODO: fix the error that player sometimes dies when stomped enemy.
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundVolume);
      }
      gotStopmed = true;
      current = State.hit;
      player.velocity.y = -_stompedHeight;
      remove(hitbox!); //removes hitbox.
      await animationTicker?.completed;
      position.y += 15;
      size = Vector2(26, 26);
      current = State.particles;
    } else {
      player.collidedWithEnemy();
    }
  }
}
