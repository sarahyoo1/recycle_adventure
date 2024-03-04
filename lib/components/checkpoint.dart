import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:recycle_adventure/components/player.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

enum State {
  idle,
  flagOut,
  noFlag,
}

class Checkpoint extends SpriteAnimationGroupComponent
    with HasGameRef<RecycleAdventure>, CollisionCallbacks {
  Checkpoint({
    super.position,
    super.size,
  });

  late final SpriteAnimation _idleSpriteAnimation;
  late final SpriteAnimation _flagOutSpriteAnimation;
  late final SpriteAnimation _noFlagSpriteAnimation;
  late Player player;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;

    _loadSpriteAnimations();

    add(
      RectangleHitbox(
        position: Vector2(18, 56),
        size: Vector2(12, 8),
        collisionType: CollisionType.passive,
      ),
    );

    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (game.isOkToNextFloor) {
      player.reachesCheckpoint();
      current = State.flagOut;
      await animationTicker?.completed;
      current = State.idle;
    }
  }

  void _loadSpriteAnimations() {
    _idleSpriteAnimation = _spriteAnimation(10, 'Flag Idle');
    _flagOutSpriteAnimation = _spriteAnimation(26, 'Flag Out')..loop = false;
    _noFlagSpriteAnimation = _spriteAnimation(1, 'No Flag');

    animations = {
      State.idle: _idleSpriteAnimation,
      State.flagOut: _flagOutSpriteAnimation,
      State.noFlag: _noFlagSpriteAnimation,
    };

    current = State.noFlag;
  }

  SpriteAnimation _spriteAnimation(int amount, String name) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint ($name) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
  }
}
