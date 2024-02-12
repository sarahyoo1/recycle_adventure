import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Background extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String imageName;
  Background({
    this.imageName = 'city3',
    super.position,
  });

  @override
  FutureOr<void> onLoad() {
    priority = -3;

    sprite = Sprite(game.images.fromCache('Background/$imageName.png'));
    return super.onLoad();
  }
}