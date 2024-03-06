import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_adventure/components/HUD/heart.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class Hud extends PositionComponent with HasGameRef<RecycleAdventure> {
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
  late TextComponent _bossHpBarLabel;
  final int maxBossLives = 100;
  bool isBossFight = false;

  @override
  FutureOr<void> onLoad() {
    if (game.floorNames[game.playerData.currentFloorIndex] == 'BossFight') {
      isBossFight = true;
      _addBossHpBarLabel();
    }

    _addFloorTextComponent();
    _addItemTextComponent();
    _addHeartHealthComponent();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateTextComponents();

    if (game.playerData.itemsCollected == game.playerData.totalItemsNum) {
      _updateItemTextStyle();
      game.playerData.isOkToNextFloor = true;
      game.playerData.save();
    }

    super.update(dt);
  }

  void _addFloorTextComponent() {
    _floorTextComponent = TextComponent(
      text: 'Floor ${game.playerData.currentFloorIndex + 1}',
      textRenderer: TextPaint(
        style: GoogleFonts.pressStart2pTextTheme().labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      anchor: Anchor.center,
      position: Vector2(560, 15),
    );
    add(_floorTextComponent);
  }

  void _addItemTextComponent() {
    _numberOfItemsCollected = TextComponent(
      text:
          'Items Collected: ${game.playerData.currentFloorIndex + 1} / ${game.playerData.totalItemsNum}',
      textRenderer: TextPaint(
        style: GoogleFonts.pressStart2pTextTheme().labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      anchor: Anchor.center,
      position: Vector2(320, 15),
    );
    add(_numberOfItemsCollected);
  }

  void _addHeartHealthComponent() async {
    for (int i = 1; i <= game.maxHealth; i++) {
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
    if (isBossFight) {
      _floorTextComponent.text = 'Boss Fight!';
      _numberOfItemsCollected.text = '';
    } else {
      _floorTextComponent.text =
          'Floor ${game.playerData.currentFloorIndex + 1}';
      _numberOfItemsCollected.text =
          'Items Collected: ${game.playerData.itemsCollected} / ${game.playerData.totalItemsNum}';
    }
  }

  void _updateItemTextStyle() {
    _numberOfItemsCollected.textRenderer = TextPaint(
      style: GoogleFonts.pressStart2pTextTheme().labelSmall?.copyWith(
            color: Colors.yellow,
            fontSize: 12,
          ),
    );
  }

  void _addBossHpBarLabel() {
    _bossHpBarLabel = TextComponent(
      text: 'HP: ',
      textRenderer: TextPaint(
        style: GoogleFonts.pressStart2pTextTheme().labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      anchor: Anchor.center,
      position: Vector2(190, 20),
    );
    add(_bossHpBarLabel);
  }
}
