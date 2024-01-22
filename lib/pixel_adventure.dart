import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/floors/floor.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() {
    return const Color(0xFF211F30);
  }

  late final CameraComponent cam;
  @override
  final world = Floor(floorName: 'Floor-02');
  @override
  FutureOr<void> onLoad() async {
    //loas all images into cache.
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 340);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
