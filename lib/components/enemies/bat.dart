import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/bullet.dart';
import 'package:pixel_adventure/components/enemy.dart';
import 'package:pixel_adventure/components/player.dart';

enum State {
  idle,
  flying,
  hit,
  ceilingIn,
  ceilingOut,
}

class Bat extends Enemy {
  Bat({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
    super.lives,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _flyingAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _ceilingInAnimation;
  late final SpriteAnimation _ceilingOutAnimation;

  Vector2 startingPoint = Vector2.zero();
  bool gotStomped = false;
  double _stompedHeight = 0;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    startingPoint = Vector2(position.x, position.y);
    _stompedHeight = 260;
    _loadAnimations();
    calculateRange();

    add(
      RectangleHitbox(
        position: Vector2(4, 0),
        size: Vector2(24, 25),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    checkLives();
    if (!gotStomped) {
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
      current = State.hit;
      await animationTicker?.completed;
      current = State.flying;
      lives--;
      other.removeFromParent();
    }
    if (other is Player) {
      game.health--;
      other.respawn();
    }
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 12);
    _flyingAnimation = _spriteAnimation('Flying', 7);
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;
    _ceilingInAnimation = _spriteAnimation('Ceiling In', 7)..loop = false;
    _ceilingOutAnimation = _spriteAnimation('Ceiling Out', 7)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.flying: _flyingAnimation,
      State.hit: _hitAnimation,
      State.ceilingIn: _ceilingInAnimation,
      State.ceilingOut: _ceilingOutAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Bat/$state (46x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.097,
        textureSize: Vector2(46, 36),
      ),
    );
  }

  void _updateState() async {
    if (velocity != Vector2.zero()) {
      current = State.flying;
    }
    //Flips enemy depending on the player's direction.
    if ((moveDirection.x > 0 && scale.x > 0) ||
        (moveDirection.x < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  @override
  void movement(dt) {
    velocity = Vector2.zero();

    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double enemyOffset = (scale.x > 0) ? 0 : -width;

    if (isPlayerInRange()) {
      targetDirection.x =
          (player.x + playerOffset < position.x + enemyOffset) ? -1 : 1;
      targetDirection.y = (player.y < position.y) ? -1 : 1;

      velocity.x = targetDirection.x * runSpeed;

      //TODO: Make the bat follow player, regardless their y position.
      velocity.y = targetDirection.y * runSpeed + 4;
    }

    //Changes enemy's direction when player changes direction.
    moveDirection.x = lerpDouble(moveDirection.x, targetDirection.x, 0.1) ?? 1;

    position += velocity * dt;
  }

  void collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) {
        FlameAudio.play('enemyKilled.wav', volume: game.soundVolume);
      }
      gotStomped = true;
      current = State.hit;
      player.velocity.y = -_stompedHeight;
      await animationTicker?.completed;
      removeFromParent();
    } else {
      player.respawn();
    }
  }

  void checkLives() {
    if (lives <= 0) {
      removeFromParent();
    }
  }
}
