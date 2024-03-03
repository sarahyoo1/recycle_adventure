import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/bullet.dart';
import 'package:pixel_adventure/components/enemy.dart';
import 'package:pixel_adventure/components/player.dart';

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
    super.lives,
  });

  static const _stompedHeight = 260.0;
  bool gotStopmed = false;

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

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
    checkLives();
    if (!gotStopmed) {
      _updateState();
      movement(dt);
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      if (game.isSoundEffectOn) {
        FlameAudio.play('damage.wav', volume: game.soundEffectVolume);
      }
      current = State.hit;
      lives--;
      other.removeFromParent();
    }
    if (other is Player) {
      _collidedWithPlayer();
    }
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 13);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 15)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
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
    if ((moveDirection.x > 0 && scale.x > 0) ||
        (moveDirection.x < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void _collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.isSoundEffectOn) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundEffectVolume);
      }
      gotStopmed = true;
      current = State.hit;
      player.velocity.y = -_stompedHeight;
      await animationTicker?.completed;
      removeFromParent();
    } else {
      game.health--;
      player.respawn();
    }
  }

  void checkLives() {
    if (lives <= 0) {
      if (game.isSoundEffectOn) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundEffectVolume);
      }
      removeFromParent();
    }
  }
}
