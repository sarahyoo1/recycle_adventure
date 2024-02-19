import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State {
  idle,
  flagOut,
  noFlag,
}

class Checkpoint extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  late final SpriteAnimation _idleSpriteAnimation;
  late final SpriteAnimation _flagOutSpriteAnimation;
  late final SpriteAnimation _noFlagSpriteAnimation;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = -1;

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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    current = State.flagOut;
    await animationTicker?.completed;
    current = State.idle;
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
