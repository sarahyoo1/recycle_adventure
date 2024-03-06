import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:recycle_adventure/components/Boss/boss.dart';
import 'package:recycle_adventure/components/Boss/item_spawn_manager.dart';
import 'package:recycle_adventure/components/HUD/boss_health_bar.dart';
import 'package:recycle_adventure/components/HUD/hud.dart';
import 'package:recycle_adventure/components/background.dart';
import 'package:recycle_adventure/components/checkpoint.dart';
import 'package:recycle_adventure/components/collision_block.dart';
import 'package:recycle_adventure/components/enemies/bat.dart';
import 'package:recycle_adventure/components/enemies/chicken.dart';
import 'package:recycle_adventure/components/enemies/cucumber.dart';
import 'package:recycle_adventure/components/enemies/slime.dart';
import 'package:recycle_adventure/components/enemies/whale.dart';
import 'package:recycle_adventure/components/item.dart';
import 'package:recycle_adventure/components/player.dart';
import 'package:recycle_adventure/components/traps/car_manager.dart';
import 'package:recycle_adventure/components/traps/hammer.dart';
import 'package:recycle_adventure/components/traps/rock_head.dart';
import 'package:recycle_adventure/components/traps/saw.dart';
import 'package:recycle_adventure/components/traps/trampoline.dart';
import 'package:recycle_adventure/components/traps/transporter.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

class Floor extends World with HasGameRef<RecycleAdventure> {
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
    _addCollisions();
    _addBackground();
    add(Hud());

    _spawningObjects();
    _updateTotalItemsNum();

    if (game.playerData.isMusicOn) {
      game.playBackgroundMusic(floorName);
    }

    return super.onLoad();
  }

  void _updateTotalItemsNum() {
    final backgroundLayer = floor.tileMap.getLayer<TileLayer>('Background');
    if (backgroundLayer != null) {
      totalItemsNum = backgroundLayer.properties.getValue('totalItemsNum');
      game.playerData.totalItemsNum = totalItemsNum;
      game.playerData.save();
    }
  }

  void _addBackground() {
    final backgroundLayer = floor.tileMap.getLayer<TileLayer>('Background');
    if (backgroundLayer != null) {
      backgroundName = backgroundLayer.properties.getValue('Background');
      addAll([Background(backgroundName: backgroundName)]);
    }
  }

  void _spawningObjects() async {
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
          case 'Item':
            final item = Item(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              item: spawnPoint.name,
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
          case 'ItemSpawnManager':
            final itemSpawnManager = ItemSpawnManager(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(itemSpawnManager);
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
          case 'Boss':
            final boss = Boss(
              position: Vector2(spawnPoint.x, spawnPoint.y + 17),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(boss);
            //adds boss health bar HUD
            for (int i = 1; i <= boss.maxLives; i++) {
              final positionX = 1.9 * i;
              await add(
                BossHealthBar(
                  boss: boss,
                  barNumber: i,
                  position: Vector2(200 + positionX.toDouble(), 13),
                  size: Vector2(2, 16),
                ),
              );
            }
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
