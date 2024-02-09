import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/components/enemy.dart';

enum State {
  idle,
  hit,
  run,
  jump,
  attack,
  blowWick,
  fall,
  ground,
  deadGround,
}

class Cucumber extends Enemy {
  Cucumber({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _jumpAnimation;
  late final SpriteAnimation _attackAnimation;
  late final SpriteAnimation _fallAnimation;
  late final SpriteAnimation _groundAnimation;
  late final SpriteAnimation _blowWickAnimation;
  late final SpriteAnimation _deadGroundAnimatiom;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    _loadAnimations();
    calculateRange();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateState();
    movement(dt);
    super.update(dt);
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 28);
    _runAnimation = _spriteAnimation('Run', 12);
    _jumpAnimation = _spriteAnimation('Jump', 4);
    _fallAnimation = _spriteAnimation('Fall', 2);
    _groundAnimation = _spriteAnimation('Ground', 3);
    _hitAnimation = _spriteAnimation('Hit', 8)..loop = false;
    _attackAnimation = _spriteAnimation('Attack', 11);
    _blowWickAnimation = _spriteAnimation('Blow the Wick', 11);
    _deadGroundAnimatiom = _spriteAnimation('Dead Ground', 4);

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.jump: _jumpAnimation,
      State.fall: _fallAnimation,
      State.ground: _groundAnimation,
      State.hit: _hitAnimation,
      State.attack: _attackAnimation,
      State.blowWick: _blowWickAnimation,
      State.deadGround: _deadGroundAnimatiom,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Cucumber/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(64, 64),
      ),
    );
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.jump : State.idle;
    //Flips enemy depending on the player's direction.
    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }
}
