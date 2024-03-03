import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_adventure/components/screens/main_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

PixelAdventure gameRef = PixelAdventure();
double soundEffectVolume = gameRef.soundVolume;
double musicVolume = gameRef.musicVolume;

class OptionMenu extends StatelessWidget {
  const OptionMenu({super.key});

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
                  Text('$soundEffectVolume'),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      gameRef.soundVolume++;
                    },
                    child: const Text("+"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      gameRef.soundVolume--;
                    },
                    child: const Text("-"),
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
                  Text('$soundEffectVolume'),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      gameRef.musicVolume++;
                    },
                    child: const Text("+"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      gameRef.musicVolume--;
                    },
                    child: const Text("-"),
                  )
                ],
              ),

              const SizedBox(height: 10),

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
