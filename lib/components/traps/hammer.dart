import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:recycle_adventure/components/player.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class Hammer extends SpriteAnimationComponent
    with HasGameRef<RecycleAdventure> {
  Hammer({
    super.position,
    super.size,
  });

  late final Player player;
  late RectangleHitbox hitbox;
  int hitboxDir = 1;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;

    animation = _spriteAnimation();

    hitbox = RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(32, 20),
    );
    add(hitbox);
    return super.onLoad();
  }


  SpriteAnimation _spriteAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Hammer/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.2,
        textureSize: Vector2(32, 64),
      ),
    );
  }

  void collidedWithPlayer() {
    game.health--;
    player.respawn();
  }
}
