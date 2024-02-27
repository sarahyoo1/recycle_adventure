import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State {
  idle,
  walk,
  dead,
}

class DroneOne extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  DroneOne({
    super.position,
    super.size,
  });

  late final SpriteAnimation _idleSpriteAnimation;
  late final SpriteAnimation _walkSpriteAnimation;
  late final SpriteAnimation _deadSpriteAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadSpriteAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x += 50 * dt;
    position.y += 40 * dt;

    if (position.x >= 623 || position.x <= -16) {
      removeFromParent();
    }
    super.update(dt);
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
}
