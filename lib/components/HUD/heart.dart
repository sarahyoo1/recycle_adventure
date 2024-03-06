import 'dart:async';

import 'package:flame/components.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

enum HeartState { available, unavailable }

class HeartHealthComponent extends SpriteGroupComponent
    with HasGameRef<RecycleAdventure> {
  final int heartNumber;
  HeartHealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _loadSprites();
  }

  @override
  void update(double dt) {
    if (game.playerData.health < heartNumber) {
      current = HeartState.unavailable;
    } else {
      current = HeartState.available;
    }
    super.update(dt);
  }

  void _loadSprites() async {
    final availableSprite = await game.loadSprite(
      'HUD/heart.png',
      srcSize: Vector2.all(16),
    );

    final unavailableSprite = await game.loadSprite(
      'HUD/heart_empty.png',
      srcSize: Vector2.all(16),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    current = HeartState.available;
  }
}
