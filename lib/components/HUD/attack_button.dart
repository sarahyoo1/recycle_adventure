import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class AttackButton extends SpriteComponent
    with HasGameRef<RecycleAdventure>, TapCallbacks {
  AttackButton();

  final margin = Vector2(64, 64);
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    priority = 10;
    sprite = Sprite(game.images.fromCache('HUD/Attack Button.png'));
    position = Vector2(
      game.size.x - margin.x - buttonSize,
      game.size.y - margin.y - buttonSize,
    );
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasShooted = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasShooted = false;
    super.onTapUp(event);
  }
}
