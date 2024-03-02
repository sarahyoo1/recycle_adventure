import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_adventure/components/screens/main_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

PixelAdventure gameRef = PixelAdventure();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark().copyWith(
      textTheme: GoogleFonts.bungeeInlineTextTheme(),
      scaffoldBackgroundColor: Colors.black,
    ),
    home: const MainMenu(),
  ));

  FlameAudio.bgm.play('main-menu-music.mp3', volume: gameRef.musicVolume);
}
