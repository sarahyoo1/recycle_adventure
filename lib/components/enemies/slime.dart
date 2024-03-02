import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/bullet.dart';
import 'package:pixel_adventure/components/enemy.dart';
import 'package:pixel_adventure/components/player.dart';

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
    super.lives,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _particlesAnimation;

  static const _stompedHeight = 260.0;

  bool dead = false;
  RectangleHitbox? hitbox;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    //add rectangle hitbox.

    hitbox = RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    );

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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      current = State.hit;
      if (lives > 0) {
        if (game.playSounds) {
          FlameAudio.play('damage.wav', volume: game.soundVolume);
        }
        lives--;
        other.removeFromParent();
      } else {
        if (game.playSounds) {
          FlameAudio.play('enemyKilled.wav', volume: game.soundVolume);
        }
        dead = true;
        onDead();
      }
    }
    if (other is Player) _collidedWithPlayer();
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
    if (!dead) {
      current = (velocity.x != 0) ? State.run : State.idle;
    }

    //Flips enemy depending on the player's direction.
    if ((moveDirection.x > 0 && scale.x > 0) ||
        (moveDirection.x < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void _collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundVolume);
      }
      dead = true;
      current = State.hit;
      player.velocity.y = -_stompedHeight;
      await animationTicker?.completed;
      onDead();
    } else {
      game.health--;
      player.respawn();
    }
  }

  void onDead() {
    if (dead) {
      remove(hitbox!);
      position.y += 15;
      size = Vector2(26, 26);
      current = State.particles;
    }
  }
}
