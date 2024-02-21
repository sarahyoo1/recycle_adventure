import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/HUD/heart.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Hud extends PositionComponent with HasGameRef<PixelAdventure> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _floorTextComponent;
  final int maxHeartNum = 5;

  @override
  FutureOr<void> onLoad() {
    _addFloorTextComponent();
    _addHeartHealthComponent();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _floorTextComponent.text = 'Floor ${game.currentFloorIndex + 1}';
    super.update(dt);
  }

  void _addFloorTextComponent() async {
    _floorTextComponent = TextComponent(
      text: 'Floor ${game.currentFloorIndex + 1}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(600, 15),
    );
    add(_floorTextComponent);
  }

  void _addHeartHealthComponent() async {
    for (int i = 1; i <= maxHeartNum; i++) {
      final positionX = 25 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble() - 10, 10),
          size: Vector2.all(16),
        ),
      );
    }
  }
}
