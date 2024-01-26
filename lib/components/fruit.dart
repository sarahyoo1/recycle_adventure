import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Fruit extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final String fruit;
  Fruit({
    this.fruit = 'Apple', //default fruit: Apple
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    priority = -1; //makes fruits go behind the player.
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
          amount: 17, stepTime: stepTime, textureSize: Vector2.all(32)),
    );
    return super.onLoad();
  }
}
