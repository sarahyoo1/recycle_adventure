import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Background extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String backgroundName;
  Background({
    this.backgroundName = 'sewer1',
    super.position,
  });

  @override
  FutureOr<void> onLoad() {
    priority = -3;

    sprite = Sprite(game.images.fromCache('Background/$backgroundName.png'));
    return super.onLoad();
  }
}
