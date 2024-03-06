import 'dart:async';

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

class DroneOne extends SpriteAnimationGroupComponent
    with HasGameRef<RecycleAdventure>, CollisionCallbacks {
  DroneOne({
    super.position,
    super.size,
  });

  int lives = 2;

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
        position: Vector2(4, 8),
        size: Vector2(40, 30),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _checkLives();
    position.x += 50 * dt;
    position.y += 40 * dt;

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
      if (game.playerData.isSoundEffectOn) {
        FlameAudio.play('boss-drone-damaged.mp3',
            volume: game.playerData.soundEffectVolume);
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
      game.images.fromCache('Boss/drone1/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.1,
        textureSize: Vector2.all(48),
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
    game.playerData.health--;
    game.playerData.save();
    player.respawn();
  }
}
