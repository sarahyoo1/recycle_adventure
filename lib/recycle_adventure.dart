import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:recycle_adventure/components/floor.dart';
import 'package:recycle_adventure/components/player.dart';
import 'package:recycle_adventure/components/player_data.dart';

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
  PlayerData playerData = PlayerData();
  Player player = Player(character: 'Hood');

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

  final int maxHealth = 5;
  bool _isAlreadyLoaded = false;

  late JoystickComponent joystick;
  late HudButtonComponent jumpButton;
  late HudButtonComponent attackButton;

  @override
  FutureOr<void> onLoad() async {
    if (!_isAlreadyLoaded) {
      await images.loadAllImages();

      _loadFloor();

      if (playerData.showControls) {
        addJoystick();
        addJumpButton();
        addAttackButton();
      }
      _isAlreadyLoaded = true;
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (playerData.showControls) {
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

  void addJumpButton() {
    jumpButton = HudButtonComponent(
      priority: 10,
      onPressed: () {
        player.hasJumped = true;
      },
      onReleased: () {
        player.hasJumped = false;
      },
      button: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Jump Button.png'),
        ),
        size: Vector2.all(64),
      ),
      margin: const EdgeInsets.only(right: 128, bottom: 32),
    );
    add(jumpButton);
  }

  void addAttackButton() {
    attackButton = HudButtonComponent(
      priority: 10,
      onPressed: () {
        player.hasShooted = true;
      },
      onReleased: () {
        player.hasShooted = false;
      },
      button: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Attack Button.png'),
        ),
        size: Vector2.all(64),
      ),
      margin: const EdgeInsets.only(right: 32, bottom: 64),
    );
    add(attackButton);
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

    if (playerData.currentFloorIndex < floorNames.length - 1) {
      playerData.currentFloorIndex++;
      playerData.save();
      _loadFloor();
    } else {
      //if there is no more floors
      playerData.currentFloorIndex = 0;
      playerData.save();
      _loadFloor();
    }
  }

  void _loadFloor() {
    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        Floor world = Floor(
          player: player,
          floorName: floorNames[playerData.currentFloorIndex],
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
    //TODO:
    playerData.currentFloorIndex = 0;
    playerData.health = 5;
    playerData.save();
  }

  void playBackgroundMusic(String floorName) {
    if (playerData.isMusicOn) {
      switch (floorName) {
        case 'Floor-01':
          FlameAudio.bgm
              .play('tutorial-music.mp3', volume: playerData.musicVolume);
          break;
        case 'Floor-02':
        case 'Floor-03':
        case 'Floor-04':
          FlameAudio.bgm
              .play('sewer-music.mp3', volume: playerData.musicVolume);
          break;
        case 'Floor-05':
        case 'Floor-06':
          FlameAudio.bgm.play('city-music.mp3', volume: playerData.musicVolume);
          break;
        case 'Floor-07':
          FlameAudio.bgm
              .play('a-short-break-music.mp3', volume: playerData.musicVolume);
          break;
        case 'Floor-08':
          FlameAudio.bgm
              .play('factory-music.mp3', volume: playerData.musicVolume);
          break;
        case 'BossFight':
          FlameAudio.bgm
              .play('boss-fight-music.mp3', volume: playerData.musicVolume);
          break;
      }
    }
  }
}
