import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/HUD/hud.dart';
import 'package:pixel_adventure/components/backgrounds/background.dart';
import 'package:pixel_adventure/components/backgrounds/background_tile.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/enemies/bat.dart';
import 'package:pixel_adventure/components/enemies/chicken.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/enemies/cucumber.dart';
import 'package:pixel_adventure/components/enemies/slime.dart';
import 'package:pixel_adventure/components/enemies/trunk.dart';
import 'package:pixel_adventure/components/enemies/whale.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/item.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/traps/car_manager.dart';
import 'package:pixel_adventure/components/traps/hammer.dart';
import 'package:pixel_adventure/components/traps/rock_head.dart';
import 'package:pixel_adventure/components/traps/saw.dart';
import 'package:pixel_adventure/components/traps/trampoline.dart';
import 'package:pixel_adventure/components/traps/transporter.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Floor extends World with HasGameRef<PixelAdventure> {
  final String floorName;
  final Player player;
  Floor({
    required this.floorName,
    required this.player,
  });
  late TiledComponent floor;
  List<CollisionBlock> collisionBlocks = [];
  late String backgroundName;
  late int totalItemsNum;

  @override
  FutureOr<void> onLoad() async {
    floor = await TiledComponent.load('$floorName.tmx', Vector2.all(16));

    add(floor);
    add(Hud());
    //_scrollingBackground();
    _addBackground();
    _spawningObjects();
    _addCollisions();
    _updateTotalItemsNum();

    return super.onLoad();
  }

  void _updateTotalItemsNum() {
    final backgroundLayer = floor.tileMap.getLayer<TileLayer>('Background');
    if (backgroundLayer != null) {
      totalItemsNum = backgroundLayer.properties.getValue('totalItemsNum');
      game.totalItemsNum = totalItemsNum;
    }
  }

  // void _scrollingBackground() {
  //   final backgroundLayer = floor.tileMap.getLayer('Background');

  //   if (backgroundLayer != null) {
  //     final backgroundColor =
  //         backgroundLayer.properties.getValue('BackgroundColor');
  //     final backgroundTile = BackgroundTile(color: backgroundColor ?? 'Gray', position: Vector2(0, 0),);
  //     add(backgroundTile);
  //     }
  //   }
  // }

  void _addBackground() {
    final backgroundLayer = floor.tileMap.getLayer<TileLayer>('Background');
    if (backgroundLayer != null) {
      backgroundName = backgroundLayer.properties.getValue('Background');
      addAll([Background(backgroundName: backgroundName)]);
    }
  }

  void _spawningObjects() {
    //adding spawn points
    final spawnPointsLayer = floor.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1; //makes player spawned facing to the right.
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              fruit: spawnPoint.name,
            );
            add(fruit);
            break;
          case 'Item':
            final item = Item(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              item: spawnPoint.name,
              amount: spawnPoint.properties.getValue('amount'),
            );
            add(item);
            break;
          case 'Saw':
            final saw = Saw(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetPositive: spawnPoint.properties.getValue('offsetPositive'),
              offsetNegative: spawnPoint.properties.getValue('offsetNegative'),
              isVertical: spawnPoint.properties.getValue('isVertical'),
              initialDirection:
                  spawnPoint.properties.getValue('initial direction'),
            );
            add(saw);
            break;
          case 'Trampoline':
            final trampoline = Trampoline(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetVertical: spawnPoint.properties.getValue('offsetVertical'),
            );
            add(trampoline);
            break;
          case 'Transporter':
            final transporter = Transporter(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              name: spawnPoint.name,
            );
            add(transporter);
            break;
          case 'Hammer':
            final hammer = Hammer(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(hammer);
            break;
          case 'RockHead':
            final rockHead = RockHead(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetHorizontal:
                  spawnPoint.properties.getValue('offsetHorizontal'),
              offsetVertical: spawnPoint.properties.getValue('offsetVertical'),
            );
            add(rockHead);
            break;
          case 'CarSpawnManager':
            final carSpawnManager = CarSpawnManager(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              direction: spawnPoint.properties.getValue('direction'),
            );
            add(carSpawnManager);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          case 'Chicken':
            final chicken = Chicken(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetPositive: spawnPoint.properties.getValue('offsetPositive'),
              offsetNegative: spawnPoint.properties.getValue('offsetNegative'),
              lives: spawnPoint.properties.getValue('lives'),
            );
            add(chicken);
            break;
          case 'Slime':
            final slime = Slime(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetPositive: spawnPoint.properties.getValue('offsetPositive'),
              offsetNegative: spawnPoint.properties.getValue('offsetNegative'),
              lives: spawnPoint.properties.getValue('lives'),
            );
            add(slime);
            break;
          case 'Bat':
            final bat = Bat(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetPositive: spawnPoint.properties.getValue('offsetPositive'),
              offsetNegative: spawnPoint.properties.getValue('offsetNegative'),
              lives: spawnPoint.properties.getValue('lives'),
            );
            add(bat);
            break;
          case 'Trunk':
            final trunk = Trunk(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetPositive: spawnPoint.properties.getValue('offsetPositive'),
              offsetNegative: spawnPoint.properties.getValue('offsetNegative'),
              lives: spawnPoint.properties.getValue('lives'),
            );
            add(trunk);
            break;
          case 'Cucumber':
            final cucumber = Cucumber(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetPositive: spawnPoint.properties.getValue('offsetPositive'),
              offsetNegative: spawnPoint.properties.getValue('offsetNegative'),
              lives: spawnPoint.properties.getValue('lives'),
            );
            add(cucumber);
            break;
          case 'Whale':
            final whale = Whale(
              position: Vector2(spawnPoint.x, spawnPoint.y + 17),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offsetPositive: spawnPoint.properties.getValue('offsetPositive'),
              offsetNegative: spawnPoint.properties.getValue('offsetNegative'),
              lives: spawnPoint.properties.getValue('lives'),
            );
            add(whale);
            break;
          default:
        }
      }
    }
  }

  //adds collisions to blocks
  void _addCollisions() {
    final collisionsLayer = floor.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
