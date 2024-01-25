import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:pixel_adventure/characters/player.dart';
import 'package:pixel_adventure/floors/floor.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() {
    return const Color(0xFF211F30);
  }

  late final CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');

  @override
  FutureOr<void> onLoad() async {
    //loas all images into cache.
    await images.loadAllImages();

    final world = Floor(player: player, floorName: 'Floor-02');

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 340);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
