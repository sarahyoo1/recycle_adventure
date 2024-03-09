import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:recycle_adventure/components/bullet.dart';
import 'package:recycle_adventure/components/player.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

enum State {
  idle,
  walk,
  dead,
}

class DroneTwo extends SpriteAnimationGroupComponent
    with HasGameRef<RecycleAdventure>, CollisionCallbacks {
  DroneTwo({
    super.position,
    super.size,
  });

  int lives = 3;

  late final SpriteAnimation _idleSpriteAnimation;
  late final SpriteAnimation _walkSpriteAnimation;
  late final SpriteAnimation _deadSpriteAnimation;
  late final Player player;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;

    _loadSpriteAnimations();
    add(
      RectangleHitbox(
        position: Vector2(35, 20),
        size: Vector2(30, 32),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _checkLives();

    position.y += 80 * dt;

    if (position.y >= game.size.y) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      if (game.isSoundEffectOn) {
        FlameAudio.play('boss-drone-damaged.mp3',
            volume: game.soundEffectVolume);
      }
      lives--;
      other.removeFromParent();
    }
    if (other is Player) {
      _collidedWithPlayer();
    }
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Boss/drone2/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.1,
        textureSize: Vector2.all(96),
      ),
    );
  }

  void _loadSpriteAnimations() {
    _idleSpriteAnimation = _spriteAnimation('Idle', 4);
    _walkSpriteAnimation = _spriteAnimation('Walk', 4);
    _deadSpriteAnimation = _spriteAnimation('Death', 6)..loop = false;

    animations = {
      State.idle: _idleSpriteAnimation,
      State.walk: _walkSpriteAnimation,
      State.dead: _deadSpriteAnimation,
    };

    current = State.idle;
  }

  void _checkLives() {
    if (lives <= 0) {
      removeFromParent();
    }
  }

  void _collidedWithPlayer() {
    game.health--;
    player.respawn();
  }
}
