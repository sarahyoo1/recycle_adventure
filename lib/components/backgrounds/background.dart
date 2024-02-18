import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Background extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String backgroundName;
  Background({
    super.position,
    super.priority = -2,
    required this.backgroundName,
  });

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Background/$backgroundName.png'));
    return super.onLoad();
  }
}
