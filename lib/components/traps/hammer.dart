import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Hammer extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  Hammer({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    animation = _spriteAnimation();
    return super.onLoad();
  }

  SpriteAnimation _spriteAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Hammer/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2(32, 64),
      ),
    );
  }
}
