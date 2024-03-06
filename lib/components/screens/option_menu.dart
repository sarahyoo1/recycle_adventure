import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:recycle_adventure/components/screens/main_menu.dart';
import 'package:recycle_adventure/main.dart';

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
                  Text(playerData.soundEffectVolume.toStringAsFixed(1)),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (playerData.soundEffectVolume < 1) {
                        setState(() {
                          playerData.soundEffectVolume += 0.1;
                          playerData.save();
                        });
                      }
                    },
                    child: const Text("+"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (playerData.soundEffectVolume > 0.1) {
                        setState(() {
                          playerData.soundEffectVolume -= 0.1;
                          playerData.save();
                        });
                      }
                    },
                    child: const Text("-"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        playerData.isSoundEffectOn =
                            !playerData.isSoundEffectOn;
                        playerData.save();
                      });
                    },
                    child: playerData.isSoundEffectOn
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
                  Text(playerData.musicVolume.toStringAsFixed(1)),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (playerData.musicVolume < 1) {
                        setState(() {
                          playerData.musicVolume += 0.1;
                          FlameAudio.bgm.audioPlayer
                              .setVolume(playerData.musicVolume);
                        });
                      }
                    },
                    child: const Text("+"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (playerData.musicVolume > 0.1) {
                        setState(() {
                          playerData.musicVolume -= 0.1;
                          playerData.save();
                          FlameAudio.bgm.audioPlayer
                              .setVolume(playerData.musicVolume);
                        });
                      }
                    },
                    child: const Text("-"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        playerData.isMusicOn = !playerData.isMusicOn;
                        if (playerData.isMusicOn) {
                          FlameAudio.bgm.resume();
                        } else {
                          FlameAudio.bgm.pause();
                        }
                      });
                    },
                    child: playerData.isMusicOn
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
