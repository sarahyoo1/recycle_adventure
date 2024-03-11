import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:recycle_adventure/components/bullet.dart';
import 'package:recycle_adventure/components/enemies/projectile/projectile_manager.dart';
import 'package:recycle_adventure/components/enemy.dart';
import 'package:recycle_adventure/components/player.dart';

enum State {
  idle,
  hit,
  run,
  jump,
  blowWick,
  fall,
  ground,
  deadGround,
  deadHit,
}

class Cucumber extends Enemy {
  late Timer _timer;
  Cucumber({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
    super.lives,
  }) {
    _timer = Timer(1, onTick: _randomlyAttack, repeat: true);
  }

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _fallAnimation;
  late final SpriteAnimation _groundAnimation;
  late final SpriteAnimation _blowWickAnimation;
  late final SpriteAnimation _deadGroundAnimatiom;
  late final SpriteAnimation _deadHitAnimatiom;
  late final EnemyProjectileManager _projectileManager;

  final int deadGroundLives = 4;

  bool hitboxActive = true;
  RectangleHitbox? hitbox;
  bool deadGround = false;
  bool isAttacking = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    _projectileManager = EnemyProjectileManager(
      position: Vector2(
        position.x,
        position.y + 20,
      ),
      limit: 0.5,
      moveDirection: moveDirection.x,
    );
    parent?.add(_projectileManager);
    _projectileManager.timer.stop();

    _loadAnimations();
    calculateRange();
    if (hitboxActive) {
      hitbox = RectangleHitbox(
        position: Vector2(15, 6),
        size: Vector2(18, 42),
      );
    }
    add(hitbox!);

    _timer.start();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _projectileManager.position = Vector2(
      position.x,
      position.y + 20,
    );
    _projectileManager.moveDirection = moveDirection.x;
    checkLives();
    if (!deadGround) {
      _updateState();
      movement(dt);
      _timer.update(dt);
    }
    super.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      if (game.isSoundEffectOn) {
        FlameAudio.play('damage.wav', volume: game.soundEffectVolume);
      }
      if (deadGround) {
        _timer.stop();
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
    _blowWickAnimation = _spriteAnimation('Blow the Wick', 11); //attack
    _deadGroundAnimatiom = _spriteAnimation('Dead Ground', 4);
    _deadHitAnimatiom = _spriteAnimation('Dead Hit', 6)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.jump: _jumpAnimation,
      State.fall: _fallAnimation,
      State.ground: _groundAnimation,
      State.hit: _hitAnimation,
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
    if (!isAttacking) {
      current = (velocity.x != 0) ? State.run : State.idle;
    }
    if (velocity.x == 0) {
      //when it is not moving, starts shooting bullet.
      _timer.resume();
    } else {
      _timer.stop();
    }

    //Flips enemy depending on the player's direction.
    if (velocity.x > 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      moveDirection.x = 1;
    } else if (velocity.x < 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      moveDirection.x = -1;
    }
  }

  void collidedWithPlayer() {
    player.respawn();
  }

  void checkLives() {
    if (lives <= 0) {
      if (game.isSoundEffectOn) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundEffectVolume);
      }
      removeFromParent();
    }
  }

  void _randomlyAttack() {
    isAttacking = true;
    current = State.blowWick;
    Future.delayed(const Duration(milliseconds: 500), () {
      _projectileManager.timer.resume();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _projectileManager.timer.stop();
      isAttacking = false;
      current = State.idle;
    });
  }
}
