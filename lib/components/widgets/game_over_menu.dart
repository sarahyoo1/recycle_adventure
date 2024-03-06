import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:recycle_adventure/components/screens/main_menu.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class GameOverMenu extends StatelessWidget {
  static const String ID = "GameOverMenu";
  final RecycleAdventure gameRef;
  const GameOverMenu({
    super.key,
    required this.gameRef,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Game Over label
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'Game Over',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 50.5,
                shadows: [
                  const Shadow(
                    blurRadius: 20.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),

          //Exit Button
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.ID);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ),
                );
                if (gameRef.playerData.isMusicOn) {
                  FlameAudio.bgm.play('main-menu-music.mp3',
                      volume: gameRef.playerData.musicVolume);
                }
              },
              child: const Text('Exit'),
            ),
          ),

          const SizedBox(height: 10),

          //TODO: Revive Button - google wallet api?
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.ID);
                gameRef.resumeEngine();
              },
              child: const Text('Revive to Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
