import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Transporter extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  String name;
  Transporter({
    super.position,
    super.size,
    required this.name,
  });

  late final double playerDeceleratedSpeed;
  late final double playerAcceleratedSpeed;

  late final Player player;
  bool isPlayerOn = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;
    animation = _spriteAnimation();

    add(
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Vector2(32, 16),
      ),
    );

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
