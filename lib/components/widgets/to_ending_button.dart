import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:recycle_adventure/components/screens/google_wallet_menu.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class ToEndingButton extends StatelessWidget {
  static const String ID = 'ToEndingButton';
  final RecycleAdventure gameRef;
  const ToEndingButton({
    super.key,
    required this.gameRef,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            gameRef.overlays.remove(ToEndingButton.ID);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GoogleWalletMenu(),
              ),
            );
            if (gameRef.isMusicOn) {
              FlameAudio.bgm
                  .play('ending-music.mp3', volume: gameRef.musicVolume);
            }
          },
          child: const Text('Click to Ending'),
        ),
      ),
    );
  }
}
