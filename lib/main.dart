import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recycle_adventure/components/screens/google_wallet_menu.dart';
import 'package:recycle_adventure/components/screens/main_menu.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

RecycleAdventure gameRef = RecycleAdventure();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(
    MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.pressStart2pTextTheme(),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainMenu(),
    ),
  );

  if (gameRef.isMusicOn) {
    FlameAudio.bgm.play('main-menu-music.mp3', volume: gameRef.musicVolume);
  }
}
