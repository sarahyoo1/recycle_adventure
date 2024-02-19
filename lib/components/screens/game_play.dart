import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

PixelAdventure _game = PixelAdventure();

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(Object context) {
    return PopScope(
        canPop: false,
        child: GameWidget(
          game: _game,
        ));
  }
}
