import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Transporter extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure> {
  String name;
  Transporter({
    super.position,
    super.size,
    required this.name,
  });

  @override
  FutureOr<void> onLoad() {
    animation = _spriteAnimation();
    return super.onLoad();
  }

  SpriteAnimation _spriteAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Transporter/$name.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
