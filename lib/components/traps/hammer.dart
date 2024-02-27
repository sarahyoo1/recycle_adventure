import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Hammer extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  Hammer({
    super.position,
    super.size,
  });

  late final Player player;
  late RectangleHitbox hitbox;
  int hitboxDir = 1;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    player = game.player;

    animation = _spriteAnimation();

    hitbox = RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(32, 20),
    );
    add(hitbox);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    print(hitbox.size.y);
    if (hitboxDir == 1) {
      if (hitbox.size.y <= 64) {
        hitbox.size.y += 73.3 * dt;
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          hitboxDir = -1;
        });
      }
    } else {
      if (hitbox.size.y >= 20) {
        hitbox.size.y -= 55 * dt;
      } else {
        hitboxDir = 1;
      }
    }
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
