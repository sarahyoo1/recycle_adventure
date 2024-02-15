import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Background extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String backgroundName;
  Background({
    this.backgroundName = 'sewer1',
    super.position,
    super.priority = -2,
  });

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Background/$backgroundName.png'));
    return super.onLoad();
  }
}
