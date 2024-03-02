import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/bullet.dart';
import 'package:pixel_adventure/components/enemies/projectile/projectile_manager.dart';
import 'package:pixel_adventure/components/enemy.dart';
import 'package:pixel_adventure/components/player.dart';

enum State {
  idle,
  run,
  hit,
  jump,
  fall,
  ground,
  attack,
  deadGround,
  deadHit,
  swallow,
}

class Whale extends Enemy {
  Whale({
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
  late final SpriteAnimation _fallAnimation;
  late final SpriteAnimation _groundAnimation;
  late final SpriteAnimation _attackAnimation;
  late final SpriteAnimation _deadGroundAnimation;
  late final SpriteAnimation _deadHitAnimation;
  late final SpriteAnimation _swallowAnimation;

  final int deadGroundLives = 4;

  bool deadGround = false;
  RectangleHitbox? hitbox;
  EnemyProjectileManager? _projectileManager;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    _loadAnimations();
    calculateRange();

    hitbox = RectangleHitbox(
      position: Vector2(4, 5),
      size: Vector2(35, 28),
    );
    add(hitbox!);

    _projectileManager = EnemyProjectileManager(
      position: Vector2(
        position.x + 9,
        position.y + 18,
      ),
      limit: 1,
    );
    parent?.add(_projectileManager!);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _checkLives();
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
    if (other is Player) _collidedWithPlayer();
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 44);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    _jumpAnimation = _spriteAnimation('Jump', 4);
    _fallAnimation = _spriteAnimation('Fall', 2);
    _groundAnimation = _spriteAnimation('Ground', 3)..loop = false;
    _attackAnimation = _spriteAnimation('Attack', 11);
    _deadGroundAnimation = _spriteAnimation('Dead Ground', 4);
    _deadHitAnimation = _spriteAnimation('Dead Hit', 6)..loop = false;
    _swallowAnimation = _spriteAnimation('Swallow', 10)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
      State.jump: _jumpAnimation,
      State.fall: _fallAnimation,
      State.ground: _groundAnimation,
      State.attack: _attackAnimation,
      State.deadGround: _deadGroundAnimation,
      State.deadHit: _deadHitAnimation,
      State.swallow: _swallowAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Whale/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(68, 68),
      ),
    );
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;

    if ((moveDirection.x > 0 && scale.x > 0) ||
        (moveDirection.x < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

//TODO: should I add stomped?
  void _collidedWithPlayer() {
    game.health--;
    player.respawn();
  }

  void _checkLives() {
    if (lives <= deadGroundLives && lives > 0) {
      deadGround = true;
      current = State.deadHit;
      _projectileManager!.removeFromParent();
    } else if (lives <= 0) {
      if (game.playSounds) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundVolume);
      }
      removeFromParent();
    }
  }
}
