import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruit;
  Fruit({
    this.fruit = 'Apple', //default fruit: Apple
    super.position,
    super.size,
    super.removeOnFinish = true,
  });

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = -1;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));

    animation = _spriteAnimation(fruit, 17, true);
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (game.playSounds) {
      FlameAudio.play('pickupItem.wav', volume: game.soundVolume);
    }
    animation = _spriteAnimation('Collected', 6, false);
    await animationTicker?.completed;
    removeFromParent();
  }

  SpriteAnimation _spriteAnimation(String name, int amount, bool isLooped) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$name.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
        loop: isLooped,
      ),
    );
  }
}
