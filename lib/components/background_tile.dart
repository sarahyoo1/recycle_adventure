import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String color;
  BackgroundTile({this.color = 'Gray', position}) : super(position: position);

  final double scrollSpeed = 0.5;
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64.5);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64;
    int scrollHeight = (game.size.y / tileSize).floor();

    //Repeats background of tiles.
    if (position.y > scrollHeight * tileSize) {
      position.y = -tileSize + 0.5;
    }
    super.update(dt);
  }
}
