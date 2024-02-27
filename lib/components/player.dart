import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:pixel_adventure/components/bullet.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/enemies/projectile/projectile.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/item.dart';
import 'package:pixel_adventure/components/traps/car.dart';
import 'package:pixel_adventure/components/traps/hammer.dart';
import 'package:pixel_adventure/components/traps/saw.dart';
import 'package:pixel_adventure/components/traps/trampoline.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/components/widgets/game_over_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  attack,
  dead,
  appearing,
  disappearing
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  Player({
    super.position,
    required this.character,
  });

  late final Player player;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;
  late final SpriteAnimation attackAnimation;
  late final SpriteAnimation deadAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 240;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  bool isHitboxActive = false;
  bool hasShooted = false;
  bool verticalShootingOn = false;
  bool dead = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitboxSetting = CustomHitbox(
    offsetX: 8,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  late final RectangleHitbox hitbox;

  double bulletHorizontalDirection = 1; //initially set to be right.

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = false;
    player = game.player;

    startingPosition = Vector2(position.x, position.y);

    if (!isHitboxActive) {
      hitbox = RectangleHitbox(
        position: Vector2(hitboxSetting.offsetX, hitboxSetting.offsetY),
        size: Vector2(hitboxSetting.width, hitboxSetting.height),
      );
      add(hitbox);
      isHitboxActive = true;
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.health <= 0) {
      dead = true;
      _dead();
    }
    if (!gotHit && !reachedCheckpoint && !dead) {
      _updatePlayerState();
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt);
      _checkVerticalCollisions();
      _checkPlayerPosition();

      if (hasShooted) {
        _shootBullet();
      }
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //initially sets direction to be none.
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    hasShooted = keysPressed.contains(LogicalKeyboardKey.keyQ) && !event.repeat;

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Item) other.collidedWithPlayer();
      if (other is Saw) other.collidedWithPlayer();
      if (other is Hammer) other.collidedWithPlayer();
      if (other is Trampoline) other.collidedWithPlayer();
      if (other is Checkpoint && !reachedCheckpoint) other.collidedWithPlayer();
      if (other is Car) other.collidedWithPlayer();
      if (other is Projectile) _collidedWithProjectile();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 4, 0.27);
    runningAnimation = _spriteAnimation('Run', 8, 0.05);
    jumpingAnimation = _spriteAnimation('Jump', 1, 0.27);
    fallingAnimation = _spriteAnimation('Fall', 1, 0.27);
    hitAnimation = _spriteAnimation('disappear', 3, 0.25)..loop = false;
    attackAnimation = _spriteAnimation('attack', 8, 0.2)..loop = false;
    deadAnimation = _spriteAnimation('dead', 8, 0.27)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7)..loop = false;
    disappearingAnimation = _specialSpriteAnimation('Disappearing', 7)
      ..loop = false;

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.attack: attackAnimation,
      PlayerState.dead: deadAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount, double stepTime) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(96),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) {
      _playerJump(dt);
    }

    //prevents jumping in air (optional).
    if (velocity.y > _gravity) {
      isOnGround = false;
    }

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    current = (velocity.x != 0) ? PlayerState.running : PlayerState.idle;

    //if going to the left.
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      bulletHorizontalDirection = -1;
      //if going to the right.
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      bulletHorizontalDirection = 1;
    }

    //checks if moving, set player's state to be running.
    if (velocity.x > 0 || velocity.x < 0) current = PlayerState.running;

    //if jumping, set state to be jumping.
    if (velocity.y < 0) current = PlayerState.jumping;

    //If falling, set state to be falling.
    if (velocity.y > _gravity) current = PlayerState.falling;
  }

  //Checks collisions with block horizontally.
  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            //when directing to the right.
            velocity.x = 0;
            position.x = block.x - hitboxSetting.offsetX - hitboxSetting.width;
            break;
          }
          if (velocity.x < 0) {
            //when directing to the left.
            velocity.x = 0;
            position.x = block.x +
                block.width +
                hitboxSetting.width +
                hitboxSetting.offsetX;
            break;
          }
        }
      }
    }
  }

  //Checks collisions with blocks vertically.
  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        //handle collisions with platform.
        if (checkCollision(this, block)) {
          //if falling
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitboxSetting.height - hitboxSetting.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        //handle collisions with any other blocks.
        if (checkCollision(this, block)) {
          //if falling
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitboxSetting.height - hitboxSetting.offsetY;
            isOnGround = true;
            break;
          }
          //if jumping
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitboxSetting.offsetY;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _playerJump(double dt) {
    if (game.playSounds) {
      FlameAudio.play('jump.wav', volume: game.soundVolume);
    }

    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    hasJumped = false;
    isOnGround = false;
  }

  void respawn() async {
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1; //makes player face to the right.
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(
      const Duration(microseconds: 400),
      () => gotHit = false,
    );
  }

  void reachesCheckpoint() async {
    reachedCheckpoint = true;
    if (game.playSounds) {
      FlameAudio.play('checkpoint.wav', volume: game.soundVolume);
    }
    if (scale.x > 0) {
      position -= Vector2.all(32);
    } else if (scale.x < 0) {
      position += Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640); //makes player out of game scene.

    Future.delayed(
      const Duration(milliseconds: 3000),
      () => game.loadNextFloor(),
    );
  }

  void _shootBullet() {
    //TODO: Player attack animation doesn't work

    Bullet bullet = Bullet(
      imagePath: 'Bullets/player_bullet.png',
      animationAmount: 4,
      moveVertically: verticalShootingOn,
      position: (bulletHorizontalDirection == 1)
          ? Vector2(position.x + 20, position.y + 20)
          : Vector2(position.x - 20, position.y + 20),
      moveDirection: bulletHorizontalDirection,
      hitbox: RectangleHitbox(
        collisionType: CollisionType.passive,
        position: Vector2(2, 9),
        size: Vector2(22, 10),
      ),
    );
    parent?.add(bullet);

    hasShooted = false;
  }

  void _dead() async {
    if (dead) {
      if (isHitboxActive) {
        remove(hitbox);
        isHitboxActive = false;
      }

      if (isOnGround) {
        current = PlayerState.dead;
        await animationTicker?.completed;

        //Game Over
        gameRef.pauseEngine();
        gameRef.overlays.add(GameOverMenu.ID);
      } else {
        dead = false;
      }
    }
  }

  void _collidedWithProjectile() {
    //TODO: add hit2 animation
    if (game.playSounds) {
      FlameAudio.play('dead.wav', volume: game.soundVolume);
    }
    game.health--;
  }

  void _checkPlayerPosition() {
    if (position.y > game.size.y) {
      game.health--;
      respawn();
    }
  }
}
