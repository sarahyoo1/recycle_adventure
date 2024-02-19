import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel_adventure/components/screens/main_menu.dart';

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
}
