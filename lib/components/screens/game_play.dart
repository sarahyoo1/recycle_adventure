import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:recycle_adventure/components/widgets/game_over_menu.dart';
import 'package:recycle_adventure/components/widgets/pause_button.dart';
import 'package:recycle_adventure/components/widgets/pause_menu.dart';
import 'package:recycle_adventure/main.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: GameWidget(
          game: gameRef,
          initialActiveOverlays: const [PauseButton.ID],
          overlayBuilderMap: {
            PauseButton.ID: (BuildContext context, RecycleAdventure gameRef) =>
                PauseButton(
                  gameRef: gameRef,
                ),
            PauseMenu.ID: (BuildContext context, RecycleAdventure gameRef) =>
                PauseMenu(
                  gameRef: gameRef,
                ),
            GameOverMenu.ID: (BuildContext context, RecycleAdventure gameRef) =>
                GameOverMenu(
                  gameRef: gameRef,
                ),
          },
        ),
      ),
    );
  }
}
