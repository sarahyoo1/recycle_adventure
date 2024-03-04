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

  final double speed = 160;
  Vector2 velocity = Vector2.zero();
  double directionX = -1;
  double directionY = 0;

  late int adjustedOffsetH;
  late int adjustedOffsetV;

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _blinkAnimation;
  late final SpriteAnimation _bottomHitAnimation;
  late final SpriteAnimation _leftHitAnimation;
  late final SpriteAnimation _rightHitAnimation;
  late final SpriteAnimation _topHitAnimation;

  late Player player;
  static const tileSize = 16;
  late final Vector2 startingPoint = position;

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
        stepTime: 0.2,
        textureSize: Vector2.all(42),
      ),
    );
  }

  void _movement(dt) async {
    //print(528 - offsetHorizontal * tileSize);
    if (directionY == 0) {
      //on horizontal movement
      if (directionX == -1) {
        //if moving to the left
        if (position.x >= 528 - offsetHorizontal * tileSize) {
          velocity.x = -speed;
        } else {
          //stop moving horizontally and start moving vertically.
          directionX = 0;
          velocity.x = 0;
          if (position.y >= 272) {
            directionY = -1; //goes up
          } else {
            directionY = 1; //goes down
          }
        }
      } else if (directionX == 1) {
        //if moving to the right
        if (position.x <= 528) {
          velocity.x = speed;
        } else {
          directionX = 0;
          velocity.x = 0;
          if (position.y >= 272 - offsetVertical * tileSize) {
            directionY = -1; //goes up
          } else {
            directionY = 1; //goes down
          }
        }
      }
    } else {
      //on vertical movement
      if (directionY == 1) {
        //if going up
        if (position.y <= 272) {
          velocity.y = speed;
        } else {
          //stop moving vertically and start moving horizontally.
          directionY = 0;
          velocity.y = 0;
          if (position.x >= 582 - offsetHorizontal * tileSize) {
            directionX = -1; //goes left
          } else {
            directionX = 1; //goes right
          }
        }
      } else if (directionY == -1) {
        //if going down
        if (position.y >= 272 - offsetVertical * tileSize) {
          velocity.y = -speed;
        } else {
          //stop moving vertically and start moving horizontally.
          directionY = 0;
          velocity.y = 0;
          if (position.x <= 582) {
            directionX = 1; //goes right
          } else {
            directionX = -1; //goes left
          }
        }
      }
    }
    position += velocity * dt;
  }

  void _checkVerticalCollisions(dt) {
    if (checkCollision(player, this)) {
      if (player.position.y < position.y) {
        player.position.x += velocity.x * dt;
        player.isOnGround = true;

        if (player.velocity.y > 0) {
          player.velocity.y = 0;
          player.position.y = position.y -
              player.hitboxSetting.height -
              player.hitboxSetting.offsetY;
        }

        if (player.velocity.y < 0) {
          player.velocity.y = 0;
          player.position.y =
              position.y + height - player.hitboxSetting.offsetY;
        }
      }
    }
  }

  void _checkHorizomtalCollisions(dt) {
    if (checkCollision(player, this)) {
      //TODO
      if (player.scale.x == 1 && player.position.x < position.x ||
          player.scale.x == -1 && player.position.x - 20 < position.x) {
        player.x = position.x -
            player.hitboxSetting.width -
            player.hitboxSetting.offsetX;
      } else if (player.position.x > position.x) {
        player.position.x = position.x +
            width +
            player.hitboxSetting.width +
            player.hitboxSetting.offsetX;
      }
    }
  }
}
