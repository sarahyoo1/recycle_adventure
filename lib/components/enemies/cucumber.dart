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
  jump,
  attack,
  blowWick,
  fall,
  ground,
  deadGround,
  deadHit,
}

class Cucumber extends Enemy {
  Cucumber({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
    super.lives,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _attackAnimation;
  late final SpriteAnimation _fallAnimation;
  late final SpriteAnimation _groundAnimation;
  late final SpriteAnimation _blowWickAnimation;
  late final SpriteAnimation _deadGroundAnimatiom;
  late final SpriteAnimation _deadHitAnimatiom;

  final int deadGroundLives = 4;

  bool hitboxActive = true;
  RectangleHitbox? hitbox;
  bool deadGround = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    _loadAnimations();
    calculateRange();
    if (hitboxActive) {
      hitbox = RectangleHitbox(
        position: Vector2(15, 6),
        size: Vector2(18, 42),
      );
    }
    add(hitbox!);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    checkLives();
    if (!deadGround) {
      _updateState();
      movement(dt);
    }

    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      if (game.playSounds) {
        FlameAudio.play('damage.wav', volume: game.soundVolume);
      }
      if (deadGround) {
        current = State.deadHit;
        await animationTicker?.completed;
        current = State.deadGround;
      } else {
        current = State.hit;
      }
      lives--;

      other.removeFromParent();
    }

    if (other is Player) {
      game.health--;
      other.respawn();
    }
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 28);
    _runAnimation = _spriteAnimation('Run', 12);
    _jumpAnimation = _spriteAnimation('Jump', 4)..loop = false;
    _fallAnimation = _spriteAnimation('Fall', 2);
    _groundAnimation = _spriteAnimation('Ground', 3)..loop = false;
    _hitAnimation = _spriteAnimation('Hit', 8)..loop = false;
    _attackAnimation = _spriteAnimation('Attack', 11);
    _blowWickAnimation = _spriteAnimation('Blow the Wick', 11);
    _deadGroundAnimatiom = _spriteAnimation('Dead Ground', 4);
    _deadHitAnimatiom = _spriteAnimation('Dead Hit', 6)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.jump: _jumpAnimation,
      State.fall: _fallAnimation,
      State.ground: _groundAnimation,
      State.hit: _hitAnimation,
      State.attack: _attackAnimation,
      State.blowWick: _blowWickAnimation,
      State.deadGround: _deadGroundAnimatiom,
      State.deadHit: _deadHitAnimatiom,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Cucumber/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(64, 64),
      ),
    );
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;
    //Flips enemy depending on the player's direction.
    if ((moveDirection.x > 0 && scale.x > 0) ||
        (moveDirection.x < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() {
    player.respawn();
  }

  void checkLives() {
    if (lives <= 0) {
      if (game.playSounds) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundVolume);
      }
      removeFromParent();
    }
  }
}
