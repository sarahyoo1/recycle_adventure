import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/enemy.dart';

enum State {
  idle,
  run,
  hit,
  attack,
}

class Trunk extends Enemy {
  Trunk({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _attackAnimation;

  bool gotStopmed = false;
  static const _stompedHeight = 260.0;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;

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
    _idleAnimation = _spriteAnimation('Idle', 18);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;
    _attackAnimation = _spriteAnimation('Attack', 11);

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
      State.attack: _attackAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Trunk/$state (64x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(32, 32),
      ),
    );
  }

  void _updateState() {
    if (!gotStopmed) {
      current = (velocity.x != 0) ? State.run : State.idle;
    }

    //Flips enemy depending on the player's direction.
    if ((moveDirection.x > 0 && scale.x > 0) ||
        (moveDirection.x < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void _shootBullets() {
    //creates bullet
    current = State.attack;
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
      await animationTicker?.completed;
      removeFromParent();
    } else {
      player.collidedWithEnemy();
    }
  }
}
