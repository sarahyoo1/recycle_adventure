import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recycle_adventure/components/player_data.dart';
import 'package:recycle_adventure/components/screens/main_menu.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

PlayerData playerData = PlayerData();
RecycleAdventure gameRef = RecycleAdventure();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  await clearHiveAndReinitialize();

  await initHive();

  runApp(const MyApp());

  if (playerData.isMusicOn) {
    FlameAudio.bgm.play('main-menu-music.mp3', volume: playerData.musicVolume);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.pressStart2pTextTheme(),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: FutureBuilder<PlayerData>(
        initialData: PlayerData(),
        future: getGameData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const MainMenu();
          }
        },
      ),
    );
  }
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path); //do not use Hive.init().
  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
}

Future<PlayerData> getGameData() async {
  final box = await Hive.openBox<PlayerData>('PlayerDataBox');
  final gameData = box.get('PlayerData');
  if (gameData == null) {
    box.put('PlayerData', PlayerData());
  }
  return box.get('PlayerData')!;
}

Future<void> clearHiveAndReinitialize() async {
  await Hive.close();

  final appDocumentDir = await getApplicationDocumentsDirectory();

  final hiveDirectory = '${appDocumentDir.path}/hive';

  final hiveDir = Directory(hiveDirectory);
  if (hiveDir.existsSync()) {
    await hiveDir.delete(recursive: true);
  }

  await Hive.initFlutter();
}
