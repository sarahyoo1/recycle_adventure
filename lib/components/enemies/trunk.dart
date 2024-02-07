import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/components/enemy.dart';

enum State {
  idle,
  run,
  hit,
  attack,
}

class Trunk extends Enemy {
  Trunk({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _attackAnimation;
  late Timer _timer;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    _loadAnimations();
    calculateRange();
    _timer = Timer(1, onTick: _shootBullets, repeat: true, autoStart: true);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _shootBullets();
    _updateState();
    movement(dt);

    super.update(dt);
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 18);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 5);
    _attackAnimation = _spriteAnimation('Attack', 11);

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
      State.attack: _attackAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Trunk/$state (64x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(64, 32),
      ),
    );
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;

    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void _shootBullets() {
    //creates bullet
  }
}
