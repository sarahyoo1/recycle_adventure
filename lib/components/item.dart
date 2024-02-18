import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Item extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String item;
  final int amount;
  Item({
    super.position,
    super.size,
    super.removeOnFinish = true,
    this.item = "Heart", //default item to be heart.
    this.amount = 22, //default heart item sprite animation amount
  });

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  bool isCollected = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = -1;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));

    animation = _spriteAnimation(item, amount);
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!isCollected) {
      isCollected = true;
      if (game.playSounds) {
        FlameAudio.play('pickupItem.wav', volume: game.soundVolume);
      }
      animation = _spriteAnimation('Collected', 6)..loop = false;
      await animationTicker?.completed;
      removeFromParent();
    }
  }

  SpriteAnimation _spriteAnimation(String path, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Else/$path.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
