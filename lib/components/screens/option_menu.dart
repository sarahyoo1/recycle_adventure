import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/screens/main_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

PixelAdventure gameRef = PixelAdventure();

class OptionMenu extends StatefulWidget {
  const OptionMenu({super.key});

  @override
  _OptionMenuState createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Menu/main_menu.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 42,
                        color: Colors.black,
                      ),
                ),
              ),

              //Sound Effect Volume Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sound Effect Volume:'),
                  const SizedBox(width: 40),
                  Text(gameRef.soundEffectVolume.toStringAsFixed(1)),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (gameRef.soundEffectVolume < 1) {
                        setState(() {
                          gameRef.soundEffectVolume += 0.1;
                        });
                      }
                    },
                    child: const Text("+"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (gameRef.soundEffectVolume > 0.1) {
                        setState(() {
                          gameRef.soundEffectVolume -= 0.1;
                        });
                      }
                    },
                    child: const Text("-"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameRef.isSoundEffectOn = !gameRef.isSoundEffectOn;
                      });
                    },
                    child: gameRef.isSoundEffectOn
                        ? const Text('On')
                        : const Text('Off'),
                  )
                ],
              ),

              const SizedBox(height: 10),

              //Background Music Volume Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Background Music Volume:'),
                  const SizedBox(width: 40),
                  Text(gameRef.musicVolume.toStringAsFixed(1)),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (gameRef.musicVolume < 1) {
                        setState(() {
                          gameRef.musicVolume += 0.1;
                          FlameAudio.bgm.audioPlayer
                              .setVolume(gameRef.musicVolume);
                        });
                      }
                    },
                    child: const Text("+"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (gameRef.musicVolume > 0.1) {
                        setState(() {
                          gameRef.musicVolume -= 0.1;
                          FlameAudio.bgm.audioPlayer
                              .setVolume(gameRef.musicVolume);
                        });
                      }
                    },
                    child: const Text("-"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameRef.isMusicOn = !gameRef.isMusicOn;
                        if (gameRef.isMusicOn) {
                          FlameAudio.bgm.resume();
                        } else {
                          FlameAudio.bgm.pause();
                        }
                      });
                    },
                    child: gameRef.isMusicOn
                        ? const Text('On')
                        : const Text('Off'),
                  )
                ],
              ),

              const SizedBox(height: 40),

              //Exit Button
              SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainMenu(),
                      ),
                    );
                  },
                  child: const Text('Exit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
