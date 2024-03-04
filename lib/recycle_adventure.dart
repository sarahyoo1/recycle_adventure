import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:recycle_adventure/components/HUD/attack_button.dart';
import 'package:recycle_adventure/components/HUD/jump_button.dart';
import 'package:recycle_adventure/components/floor.dart';
import 'package:recycle_adventure/components/player.dart';

class RecycleAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  //sets default background color
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  Player player = Player(character: 'Hood');
  final int maxHealth = 5;
  late int health; //player health
  int itemsCollected = 0;
  int totalItemsNum = 0;
  bool isOkToNextFloor = false;
  late JoystickComponent joystick;
  bool showControls = true; //turns on and off joysticks and other buttons
  bool isSoundEffectOn = true;
  bool isMusicOn = true;
  double soundEffectVolume = 1.0;
  double musicVolume = 1.0;
  List<String> floorNames = [
    'Floor-01',
    'Floor-02',
    'Floor-03',
    'Floor-04',
    'Floor-05',
    'Floor-06',
    'Floor-07',
    'Floor-08',
    'BossFight',
  ];
  int currentFloorIndex = 0; //Should initially set to be 0.

  bool _isAlreadyLoaded = false;

  @override
  FutureOr<void> onLoad() async {
    health = maxHealth;
    if (!_isAlreadyLoaded) {
      await images.loadAllImages();

      _loadFloor();

      if (showControls) {
        addJoystick();
        add(JumpButton());
        add(AttackButton());
      }
      _isAlreadyLoaded = true;
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      knobRadius: 64,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextFloor() {
    removeWhere((component) => component is Floor);

    if (currentFloorIndex < floorNames.length - 1) {
      currentFloorIndex++;
      _loadFloor();
    } else {
      //if there is no more floors
      currentFloorIndex = 0;
      _loadFloor();
    }
  }

  void _loadFloor() {
    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        Floor world = Floor(
          player: player,
          floorName: floorNames[currentFloorIndex],
        );

        cam = CameraComponent.withFixedResolution(
          world: world,
          width: 640,
          height: 340,
        );
        cam.viewfinder.anchor = Anchor.topLeft;

        addAll([cam, world]);
      },
    );
  }

  void reset() {
    currentFloorIndex = 0;
    health = 5;
  }

  void playBackgroundMusic(String floorName) {
    if (isMusicOn) {
      switch (floorName) {
        case 'Floor-01':
          FlameAudio.bgm.play('tutorial-music.mp3', volume: musicVolume);
          break;
        case 'Floor-02':
        case 'Floor-03':
        case 'Floor-04':
          FlameAudio.bgm.play('sewer-music.mp3', volume: musicVolume);
          break;
        case 'Floor-05':
        case 'Floor-06':
          FlameAudio.bgm.play('city-music.mp3', volume: musicVolume);
          break;
        case 'Floor-07':
          FlameAudio.bgm.play('a-short-break-music.mp3', volume: musicVolume);
          break;
        case 'Floor-08':
          FlameAudio.bgm.play('factory-music.mp3', volume: musicVolume);
          break;
        case 'BossFight':
          FlameAudio.bgm.play('boss-fight-music.mp3', volume: musicVolume);
          break;
      }
    }
  }
}
