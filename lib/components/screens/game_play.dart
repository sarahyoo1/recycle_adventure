import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/widgets/game_over_menu.dart';
import 'package:pixel_adventure/components/widgets/pause_button.dart';
import 'package:pixel_adventure/components/widgets/pause_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

PixelAdventure _game = PixelAdventure();

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: GameWidget(
          game: _game,
          initialActiveOverlays: const [PauseButton.ID],
          overlayBuilderMap: {
            PauseButton.ID: (BuildContext context, PixelAdventure gameRef) =>
                PauseButton(
                  gameRef: gameRef,
                ),
            PauseMenu.ID: (BuildContext context, PixelAdventure gameRef) =>
                PauseMenu(
                  gameRef: gameRef,
                ),
            GameOverMenu.ID: (BuildContext context, PixelAdventure gameRef) =>
                GameOverMenu(
                  gameRef: gameRef,
                ),
          },
        ),
      ),
    );
  }
}
