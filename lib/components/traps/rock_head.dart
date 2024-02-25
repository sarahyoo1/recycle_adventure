import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State {
  idle,
  blink,
  bottomHit,
  leftHit,
  rightHit,
  topHit,
}

class RockHead extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  final bool isPlatform;
  final int offsetHorizontal;
  final int offsetVertical;
  RockHead({
    super.position,
    super.size,
    this.isPlatform = false,
    required this.offsetHorizontal,
    required this.offsetVertical,
  });

  double direction = -1;

  final double speed = 160;
  Vector2 velocity = Vector2.zero();
  double directionX = 0;
  double directionY = 0;

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _blinkAnimation;
  late final SpriteAnimation _bottomHitAnimation;
  late final SpriteAnimation _leftHitAnimation;
  late final SpriteAnimation _rightHitAnimation;
  late final SpriteAnimation _topHitAnimation;

  late Player player;
  static const tileSize = 16;
  late double rangeNegativeH,
      rangePositiveH,
      rangeNegativeV,
      rangePositiveV = 0;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;

    _loadSpriteAnimations();

    add(
      RectangleHitbox(
        position: Vector2(5, 5),
        size: Vector2(38, 38),
      ),
    );

    rangeNegativeH = position.x - offsetHorizontal * tileSize;
    rangePositiveH = position.x + offsetHorizontal * tileSize;
    rangeNegativeV = position.y - offsetVertical * tileSize;
    rangePositiveV = position.y + offsetVertical * tileSize;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _checkVerticalCollisions(dt);
    _checkHorizomtalCollisions(dt);
    _movement(dt);
  }

  void _loadSpriteAnimations() {
    _blinkAnimation = _spriteAnimation('Blink', 4);
    _idleAnimation = _spriteAnimation('Idle', 1);
    _leftHitAnimation = _spriteAnimation('Left Hit', 4)..loop = false;
    _rightHitAnimation = _spriteAnimation('Right Hit', 4)..loop = false;
    _topHitAnimation = _spriteAnimation('Top Hit', 4)..loop = false;
    _bottomHitAnimation = _spriteAnimation('Bottom Hit', 4)..loop = false;

    animations = {
      State.blink: _blinkAnimation,
      State.idle: _idleAnimation,
      State.leftHit: _leftHitAnimation,
      State.rightHit: _rightHitAnimation,
      State.topHit: _topHitAnimation,
      State.bottomHit: _bottomHitAnimation,
    };

    current = State.blink;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Rock Head/$state (42x42).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(42),
      ),
    );
  }

  void _movement(double dt) async {
    //print("this pos: ${position.y}");
    // print("result: ${offsetHorizontal * tileSize + position.x}");
    // print("threshold: ${offsetVertical * tileSize * 1.31}");
    if (position.x >= offsetHorizontal * tileSize / 8) {
      directionX = -1;
      directionY = 0;
    }
    if (position.x <= offsetHorizontal * tileSize / 8) {
      directionX = 0;
      directionY = -1;
    }
    if (position.y <= offsetVertical * tileSize / 5) {
      directionX = 1;
      directionY = 0;
    }
    if (position.x >= offsetHorizontal * tileSize * 1.14) {
      directionX = 0;
      directionY = 1;
    }
    if (position.x >= offsetHorizontal * tileSize * 1.14 &&
        position.y >= offsetVertical * tileSize * 1.31) {
      directionX = -1;
      directionY = 0;
    }
    velocity.x = speed * directionX;
    velocity.y = speed * directionY;

    position += velocity * dt;
  }

  void _checkVerticalCollisions(dt) {
    if (checkCollision(player, this)) {
      player.position.x += velocity.x * dt;

      if (player.velocity.y > 0) {
        player.velocity.y = 0;
        player.position.y = position.y -
            player.hitboxSetting.height -
            player.hitboxSetting.offsetY;
        player.isOnGround = true;
      }

      if (player.velocity.y < 0) {
        player.isOnGround = false;
        player.velocity.y = 0;
        player.position.y = position.y + height - player.hitboxSetting.offsetY;
      }
    }
  }

  void _checkHorizomtalCollisions(dt) {
    if (checkCollision(player, this)) {
      //when going right
      if (player.velocity.x > 0 && player.position.x < position.x) {
        player.velocity.x = 0;
        player.x = position.x -
            player.hitboxSetting.offsetX -
            player.hitboxSetting.width;
      }
      //when going left
      if (player.velocity.x < 0 && player.position.x > position.x) {
        player.velocity.x = 0;
        player.position.x = position.x +
            width +
            player.hitboxSetting.width +
            player.hitboxSetting.offsetX;
      }
    }
  }
}
