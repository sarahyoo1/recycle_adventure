import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/screens/main_menu.dart';
import 'package:pixel_adventure/components/widgets/pause_button.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class PauseMenu extends StatelessWidget {
  static const String ID = 'PauseMenu';
  final PixelAdventure gameRef;
  const PauseMenu({
    super.key,
    required this.gameRef,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Paused Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'Paused',
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

          //Resume Button
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: ElevatedButton(
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
              },
              child: const Text('Resume'),
            ),
          ),

          const SizedBox(height: 10),

          //Restart Button
          // SizedBox(
          //   width: MediaQuery.of(context).size.width / 5,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       gameRef.overlays.remove(PauseMenu.ID);
          //       gameRef.overlays.add(PauseButton.ID);
          //       gameRef.reset();
          //       gameRef.resumeEngine();
          //     },
          //     child: const Text('Restart'),
          //   ),
          // ),
          // const SizedBox(height: 10),

          //Exit Button
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ),
                );
                //gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text('Exit'),
            ),
          ),
        ],
      ),
    );
  }
}