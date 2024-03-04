import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<RecycleAdventure>, TapCallbacks {
  JumpButton({super.priority = 10});

  final margin = Vector2(128, 32);
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/Jump Button.png'));
    position = Vector2(
      game.size.x - margin.x - buttonSize,
      game.size.y - margin.y - buttonSize,
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
