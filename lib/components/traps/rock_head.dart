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
  bool isPlatform;
  RockHead({
    super.position,
    super.size,
    this.isPlatform = false,
  });

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
        stepTime: 0.05,
        textureSize: Vector2.all(42),
      ),
    );
  }

  void _movement(double dt) async {
    if (position.x > 0 && position.y > 270) {
      current = State.bottomHit;

      directionX = -1;
      directionY = 0;
    } else if (position.x < 0 && position.y > 0) {
      current = State.leftHit;

      directionX = 0;
      directionY = -1;
    } else if (position.x < 0 && position.y < 0) {
      current = State.topHit;

      directionX = 1;
      directionY = 0;
    } else if (position.x > 590 && position.y < 0) {
      current = State.rightHit;

      directionX = 0;
      directionY = 1;
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
