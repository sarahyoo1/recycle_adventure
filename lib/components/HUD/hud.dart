import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/src/text/renderers/text_renderer.dart';
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
  late TextComponent _numberOfItemsCollected;
  final int maxHeartNum = 5;

  @override
  FutureOr<void> onLoad() {
    _addFloorTextComponent();
    _addItemTextComponent();
    _addHeartHealthComponent();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateTextComponents();
    if (game.itemsCollected == game.totalItemsNum) {
      _updateItemTextStyle();
      game.isOkToNextFloor = true;
    }
    super.update(dt);
  }

  void _addFloorTextComponent() {
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

  void _addItemTextComponent() {
    _numberOfItemsCollected = TextComponent(
      text:
          'Items Collected: ${game.currentFloorIndex + 1} / ${game.totalItemsNum}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(300, 15),
    );
    add(_numberOfItemsCollected);
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

  void _updateTextComponents() {
    _floorTextComponent.text = 'Floor ${game.currentFloorIndex + 1}';
    _numberOfItemsCollected.text =
        'Items Collected: ${game.itemsCollected} / ${game.totalItemsNum}';
  }

  void _updateItemTextStyle() {
    _numberOfItemsCollected.textRenderer = TextPaint(
      style: const TextStyle(
        color: Colors.amber,
        fontSize: 16,
      ),
    );
  }
}
