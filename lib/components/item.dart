import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:recycle_adventure/components/custom_hitbox.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class Item extends SpriteAnimationComponent
    with HasGameRef<RecycleAdventure>, CollisionCallbacks {
  final String item;
  Item({
    super.position,
    super.size,
    super.removeOnFinish = true,
    required this.item,
  });

  final double stepTime = 0.05;
  late final CustomHitbox hitbox;

  bool isCollected = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;

    _loadAnimation(); //must come before adding hitbox since it decalres hitbox setting.

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));

    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!isCollected) {
      isCollected = true;

      animation = _specialSpriteAnimation('Collected', 6)..loop = false;
      await animationTicker?.completed;

      if (item == 'Heart') {
        if (game.playerData.isSoundEffectOn) {
          FlameAudio.play('health-up.mp3',
              volume: game.playerData.soundEffectVolume);
        }
        if (game.playerData.health < 5) {
          game.playerData.health++;
          game.playerData.save();
        }
      } else {
        if (game.playerData.isSoundEffectOn) {
          FlameAudio.play('pickupItem.wav',
              volume: game.playerData.soundEffectVolume);
        }
        game.playerData.itemsCollected++;
        game.playerData.save();
      }
      removeFromParent();
    }
  }

  void _loadAnimation() {
    switch (item) {
      case 'Heart':
        hitbox = CustomHitbox(
          offsetX: 10,
          offsetY: 10,
          width: 12,
          height: 12,
        );
        animation = _elseItemSpriteAnimation(10);
        break;
      case 'Plastic Bag':
        hitbox = CustomHitbox(
          offsetX: 10,
          offsetY: 10,
          width: 12,
          height: 12,
        );
        animation = _specialSpriteAnimation('Recycle Items/$item', 11);
        break;
      case 'Plastic Bottle':
        hitbox = CustomHitbox(
          offsetX: 10,
          offsetY: 10,
          width: 12,
          height: 12,
        );
        animation = _specialSpriteAnimation('Recycle Items/$item', 11);
        break;
      default:
        //other recycle items
        hitbox = CustomHitbox(
          offsetX: 4,
          offsetY: 5,
          width: 12,
          height: 12,
        );
        animation = _recycleItemSpriteAnimation();
        break;
    }
  }

  SpriteAnimation _elseItemSpriteAnimation(int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Else/$item.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _recycleItemSpriteAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Recycle Items/$item.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String path, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/$path.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
