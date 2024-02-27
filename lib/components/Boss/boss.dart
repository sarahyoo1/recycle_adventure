import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:pixel_adventure/components/Boss/drone_spawn_manager.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State {
  idle,
  walk,
  move,
  hit,
  attack1,
  attack2,
  attack3,
  attack4,
  dead,
}

class Boss extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  late Timer _timer;
  Boss({
    super.position,
    super.size,
  }) : super() {
    _timer = Timer(1,
        onTick: _randomlyChoosePattern,
        repeat: true); //randomly chooses pattern every second.
  }

  late final SpriteAnimation _idleSpriteAnimation;
  late final SpriteAnimation _walkSpriteAnimation;
  late final SpriteAnimation _moveSpriteAnimation;
  late final SpriteAnimation _hitSpriteAnimation;
  late final SpriteAnimation _attack1SpriteAnimation;
  late final SpriteAnimation _attack2SpriteAnimation;
  late final SpriteAnimation _attack3SpriteAnimation;
  late final SpriteAnimation _attack4SpriteAnimation;
  late final SpriteAnimation _deadSpriteAnimation;

  final _lives = 10;
  bool dead = false;
  Vector2 velocity = Vector2.zero();
  late double directionX;
  double moveSpeed = 80;

  bool onPattern1 = false;
  bool onPattern2 = false;

  @override
  FutureOr<void> onLoad() {
    _loadSpriteAnimations();
    _timer.start();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!dead) {
      _updateState();
      _movement(dt);
      _timer.update(dt);

      if (onPattern1) {
        _pattern1();
      }
    }
    super.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Boss/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2(85, 85),
      ),
    );
  }

  void _loadSpriteAnimations() {
    _idleSpriteAnimation = _spriteAnimation('idle', 4);
    _walkSpriteAnimation = _spriteAnimation('walk', 6);
    _moveSpriteAnimation = _spriteAnimation('move', 6);
    _hitSpriteAnimation = _spriteAnimation('hit', 2)..loop = false;
    _attack1SpriteAnimation = _spriteAnimation('attack-1', 6)..loop = false;
    _attack2SpriteAnimation = _spriteAnimation('attack-2', 6)..loop = false;
    _attack3SpriteAnimation = _spriteAnimation('attack-3', 6)..loop = false;
    _attack4SpriteAnimation = _spriteAnimation('attack-4', 6)..loop = false;
    _deadSpriteAnimation = _spriteAnimation('dead', 6)..loop = false;

    animations = {
      State.idle: _idleSpriteAnimation,
      State.walk: _walkSpriteAnimation,
      State.move: _moveSpriteAnimation,
      State.hit: _hitSpriteAnimation,
      State.attack1: _attack1SpriteAnimation,
      State.attack2: _attack2SpriteAnimation,
      State.attack3: _attack3SpriteAnimation,
      State.attack4: _attack4SpriteAnimation,
      State.dead: _deadSpriteAnimation,
    };

    current = State.move;
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.walk : State.idle;
  }

  void _movement(dt) {
    position.x += velocity.x * dt;
  }

  void _randomlyChoosePattern() {
    if (!onPattern1 && !onPattern2) {
      int rd = Random().nextInt(2);

      switch (rd) {
        case 0:
          onPattern1 = true;
          _pattern1();
          print("pattern 1 choosed");
          break;
        case 1:
          onPattern2 = true;
          _pattern2();
          print("pattern 2 choosed");
          break;
      }
    }
  }

  void _pattern1() {
    directionX = -1;

    if (directionX == -1) {
      if (position.x >= 100) {
        // Move left
        velocity.x = -1 * 80;
      } else {
        // Change direction after a delay
        velocity.x = 0;
        current = State.attack3;
        Future.delayed(const Duration(seconds: 1), () {
          directionX = 1;
        });
      }
    } else if (directionX == 1) {
      if (position.x < 512) {
        // Move right
        velocity.x = 1 * 80;
      } else {
        // Stop and change direction after a delay
        velocity.x = 0;
        current = State.attack4;
        Future.delayed(const Duration(seconds: 1), () {
          directionX = -2;
        });
      }
    }

    // Handle movement for directionX == -2
    if (directionX == -2) {
      if (position.x > 272) {
        // Move left
        velocity.x = -1 * 80;
      } else {
        // Stop, print message, and set flag
        velocity.x = 0;
        onPattern1 = false;
      }
    }
  }

  void _pattern2() {
    DroneSpawnManager droneSpawnManager =
        DroneSpawnManager(position: position, limit: 0.5);
    add(droneSpawnManager);

    //spawns drones for 10 seconds.
    Future.delayed(const Duration(seconds: 10), () {
      remove(droneSpawnManager);
      onPattern2 = false;
    });
  }
}
