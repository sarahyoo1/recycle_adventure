import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/widgets/pause_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class PauseButton extends StatelessWidget {
  static const String ID = 'PauseButton';
  final PixelAdventure gameRef;
  const PauseButton({
    super.key,
    required this.gameRef,
  });

  @override
  Widget build(Object context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
        child: const Icon(
          Icons.pause_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          gameRef.pauseEngine();
          FlameAudio.bgm.pause();
          gameRef.overlays.add(PauseMenu.ID);
          gameRef.overlays.remove(PauseButton.ID);
        },
      ),
    );
  }
}
